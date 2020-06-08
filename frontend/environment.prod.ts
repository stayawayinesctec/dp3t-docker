import {OIdC} from '../app/auth/open-id-config-service';

export const environment = {
	production: true,
	showWarning: false,
	host: 'https://localhost',
	eiamSelfAdmin:
		'',
	oidc: {
		clientId: 'ha-ui-web-client',
		afterLoginPath: 'generate-code',
		stsServer: 'https://localhost/auth/realms/bag-pts',
		applicationUrl: 'https://localhost/',
		loginFeedback: 'auth/login-feedback/',
		silentRenew: true,
		useAutoLogin: false,
		debug: false,
		tokenAwareUrlPatterns: ['/v1/(authcode).*']
	} as OIdC
};
