create: keycloak_admin.txt backend_db.txt keycloak_db.txt authcode_db.txt
	make -C authtoken
	make -C backend

keycloak_admin.txt:
	( < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16;echo ) > .keycloak_admin.tmp
	mv -n .keycloak_admin.tmp keycloak_admin.txt
	rm -f .keycloak_admin.tmp

keycloak_db.txt:
	( < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16;echo ) > .keycloak_db.tmp
	mv -n .keycloak_db.tmp keycloak_db.txt
	rm -f .keycloak_db.tmp

backend_db.txt:
	( < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16;echo ) > .backend_db.tmp
	mv -n .backend_db.tmp backend_db.txt
	rm -f .backend_db.tmp

authcode_db.txt:
	( < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16;echo ) > .authcode_db.tmp
	mv -n .authcode_db.tmp authcode_db.txt
	rm -f .authcode_db.tmp

load: create
	docker secret create dp3t_authtoken_private - < authtoken/private.pem || true
	docker secret create dp3t_authtoken_public - < authtoken/pub.pem || true
	docker secret create dp3t_backend_private - < backend/private.pem || true
	docker secret create dp3t_backend_public - < backend/pub.pem || true
	docker secret create dp3t_keycloak_admin - < keycloak_admin.txt || true
	docker secret create dp3t_keycloak_db - < keycloak_db.txt || true
	docker secret create dp3t_backend_db - < backend_db.txt || true
	docker secret create dp3t_authcode_db - < authcode_db.txt || true

unload:
	docker secret rm dp3t_authtoken_private || true
	docker secret rm dp3t_authtoken_public || true
	docker secret rm dp3t_backend_private || true
	docker secret rm dp3t_backend_public || true
	docker secret rm dp3t_keycloak_admin || true
	docker secret rm dp3t_keycloak_db || true
	docker secret rm dp3t_backend_db || true
	docker secret rm dp3t_authcode_db || true

clean:
	make -C authtoken clean
	make -C backend clean
	rm -f .??*.tmp

destroy:
	make -C authtoken destroy
	make -C backend destroy
	rm -f keycloak_admin.txt backend_db.txt keycloak_db.txt authcode_db.txt
