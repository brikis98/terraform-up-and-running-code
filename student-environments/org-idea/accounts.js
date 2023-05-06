const accounts 	= require('./accounts.json')
const shell 		= require('shelljs')

accounts.names.forEach((account) => {
	console.log(`Ensuring that the account rockholla-di-${account} is created...`)
	let result = shell.exec(`./new-aws-org-account.sh --account_name rockholla-di-${account} --account_email di+${account}@rockholla.org --cl_profile_name rockholla-di-${account}`)
	if (result.code != 0) {
		console.error(`Error creating org account ${account}`)
	}
	console.log(`Done with rockholla-di-${account}`)
	console.log('-----------------------------------------------------------------------')
})