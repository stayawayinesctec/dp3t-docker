

pub.pem private.pem: GenerateKeyPair.class
	java GenerateKeyPair
	mv -n generated_pub.pem pub.pem
	mv -n generated_private.pem private.pem
	rm -f generated_pub.pem generated_private.pem
	touch pub.pem private.pem

bcpkix-jdk15on-1.65.jar:
	mvn dependency:get -Dartifact=org.bouncycastle:bcpkix-jdk15on:1.65 -Ddest=.

GenerateKeyPair.class: ../../backendws/dp3t-sdk-backend/GenerateKeyPair.java
	javac -d . $<

clean:
	rm -f GenerateKeyPair.class generated_*.pem

destroy:
	rm -f pub.pem private.pem
