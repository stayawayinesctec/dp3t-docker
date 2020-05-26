export const environment = {
	production: true,
	showWarning: false,
	host: 'https://localhost',
	eiamSelfAdmin:
		'',
	oidc: {
		clientId: 'ha-ui-web-client',
		afterLoginPath: '/generate-code',
		stsServer: 'https://localhost/auth/realms/bag-pts',
		applicationUrl: 'https://localhost/auth/login-feedback/',
		post_logout_redirect_uri: 'https://localhost/',
		silentRenew: true,
		useAutoLogin: false,
		debug: false,
		token_aware_url_patterns: ['/v1/(authcode).*']
	}
};
