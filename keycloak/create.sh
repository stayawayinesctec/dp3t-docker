#!/usr/bin/env bash

BAG_URL="https://localhost"
BAG_NAME="Health Authority"

function setup_bagpts() {
	KCADM=/opt/jboss/keycloak/bin/kcadm.sh
	REALM=bag-pts

	echo "Waiting for server startup..."
	while ! curl -s http://localhost:8080/auth -o /dev/null; do sleep 5; done

	echo "KeyCloak configuration for ${BAG_NAME} starting..."
	$KCADM config credentials --server http://localhost:8080/auth \
		--realm master --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD

	# For debugging
	#$KCADM delete realms/$REALM

	if $KCADM create realms -s realm=$REALM -s enabled=true -s displayName="$BAG_NAME"; then
		echo "Created $REALM realm"
	else
		echo "Cannot create $REALM: already exists?"
		return 1
	fi

	$KCADM update events/config -s "eventsEnabled=true" -s "adminEventsEnabled=true" -s "eventsListeners+=metrics-listener"

	csid=$($KCADM create client-scopes -r $REALM -s name=ha-ui -s protocol=openid-connect \
		-s attributes.\"include.in.token.scope\"=true \
		-s attributes.\"display.in.consent.screen\"=false --id)
	$KCADM create client-scopes/$csid/protocol-mappers/models -r $REALM \
		-s name="Audience for ha-ui-web-client" \
		-s protocol=openid-connect -s protocolMapper=oidc-audience-mapper \
		-s config.\"included.custom.audience\"=ha-authcodegeneration \
		-s config.\"id.token.claim\"=true \
		-s config.\"access.token.claim\"=true
	echo "Created client scope $csid"
	
	cid=$($KCADM create clients -r $REALM -s clientId=ha-ui-web-client -s enabled=true \
		-s redirectUris="[\"$BAG_URL/*\"]" -s webOrigins="[\"$BAG_URL\"]" \
		-s directAccessGrantsEnabled=true -s publicClient=true \
		-s rootUrl="" --id)
	$KCADM create clients/$cid/protocol-mappers/models -r $REALM \
		-s name=userroles -s config.multivalued=true \
		-s config.\"user.attribute\"=userroles -s config.\"claim.name\"=userroles \
		-s protocol=openid-connect -s protocolMapper=oidc-usermodel-attribute-mapper \
		-s config.\"included.custom.audience\"=ha-authcodegeneration \
		-s config.\"id.token.claim\"=true -s config.\"access.token.claim\"=true \
		-s config.\"jsonType.label\"=String
	$KCADM create clients/$cid/protocol-mappers/models -r $REALM \
		-s name=ctx \
		-s config.\"user.attribute\"=ctx -s config.\"claim.name\"=ctx \
		-s protocol=openid-connect -s protocolMapper=oidc-usermodel-attribute-mapper \
		-s config.\"included.custom.audience\"=ha-authcodegeneration \
		-s config.\"id.token.claim\"=true -s config.\"access.token.claim\"=true \
		-s config.\"jsonType.label\"=String
	echo "Created client $cid"
	
	$KCADM update --no-merge clients/$cid/default-client-scopes/$csid -r $REALM \
		-s clientScopeId=$csid
	echo "Added scope $csid to client $cid"
	
	gid=$($KCADM create groups -r $REALM -s name=bag-pts-allowed --id)
	$KCADM update groups/$gid -r $REALM -s attributes.userroles+=bag-pts-allow
	$KCADM update groups/$gid -r $REALM -s attributes.ctx+=USER
	echo "Created group $gid"

	if [[ -n ${BAG_USER:-} && -n ${BAG_PASSWORD:-} ]]; then
		uid=$($KCADM create users -r $REALM -s username=$BAG_USER -s enabled=true --id)
		$KCADM update users/$uid/groups/$gid -r $REALM \
			-s realm=$REALM -s userId=$uid -s groupId=$gid -n
		$KCADM set-password -r $REALM --username $BAG_USER --new-password $BAG_PASSWORD
		echo "Added user $uid"
	fi
	
	echo "KeyCloak configuration for ${BAG_NAME} done."

	# Bye bye...
	rm -f /opt/jboss/.keycloak/kcadm.config
}

setup_bagpts &
