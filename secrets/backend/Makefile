

pub.pem private.pem: GenerateKeyPairEC.class bcpkix-jdk15on-1.65.jar bcprov-jdk15on-1.65.jar
	java -cp .:bcpkix-jdk15on-1.65.jar:bcprov-jdk15on-1.65.jar GenerateKeyPairEC
	mv -n generated_pub.pem pub.pem
	mv -n generated_private.pem private.pem
	rm -f generated_pub.pem generated_private.pem
	touch pub.pem private.pem

bcpkix-jdk15on-1.65.jar:
	mvn dependency:get -Dartifact=org.bouncycastle:bcpkix-jdk15on:1.65 -Ddest=.

bcprov-jdk15on-1.65.jar:
	mvn dependency:get -Dartifact=org.bouncycastle:bcprov-jdk15on:1.65 -Ddest=.

GenerateKeyPairEC.class: ../../backendws/dp3t-sdk-backend/GenerateKeyPairEC.java bcpkix-jdk15on-1.65.jar bcprov-jdk15on-1.65.jar
	javac -d . -cp bcpkix-jdk15on-1.65.jar:bcprov-jdk15on-1.65.jar ../../backendws/dp3t-sdk-backend/GenerateKeyPairEC.java 

clean:
	rm -f GenerateKeyPairEC.class bcprov-jdk15on-1.65.jar bcpkix-jdk15on-1.65.jar generated_*.pem

destroy:
	rm -f pub.pem private.pem
