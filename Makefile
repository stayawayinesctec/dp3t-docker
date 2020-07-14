
images:
	rm -rf backendws/dp3t-sdk-backend-build && \
		git clone backendws/dp3t-sdk-backend backendws/dp3t-sdk-backend-build && \
		(cd backendws/dp3t-sdk-backend; git diff)|(cd backendws/dp3t-sdk-backend-build; patch -p1)
	rm -rf authcodews/CovidCode-Service-build && \
		git clone authcodews/CovidCode-Service authcodews/CovidCode-Service-build && \
		(cd authcodews/CovidCode-Service; git diff)|(cd authcodews/CovidCode-Service-build; patch -p1)
	docker-compose build
	rm -rf backendws/dp3t-sdk-backend-build authcodews/CovidCode-Service-build
