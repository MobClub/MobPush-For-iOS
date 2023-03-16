node {
	properties([parameters([
		choice(name: 'Credential_ID', choices: ['', 'pangjj', 'yz'], description: 'Required, Used to checkout the config files and source code.'),
		choice(name: 'Xcode', choices: ['Xcode_12', 'Xcode'], description: 'Required, Change the default xcode to pod trunk.'),
		string(name: 'Job_Name', defaultValue: 'MobPush', description: 'The target job name.'),
		string(name: 'Branch', defaultValue: 'master', description: 'The target branch name.'),
		string(name: 'Version', defaultValue: '', description: 'The target sdk version, such as v1.1.1.'),
		string(name: 'Framework', defaultValue: 'MobPush', description: 'The framework name used to check.'),
		string(name: 'Config_Folder', defaultValue: 'mobpush_repo', description: 'The config files folder name.'),
		string(name: 'AliYun_Obj', defaultValue: 'pushsdk', description: 'The minio bucket name.'),
		string(name: 'Zip', defaultValue: '', description: 'The zip name, e.g. MobLinkPro_For_iOS_v3.3.11.zip'),
		string(name: 'Jira_Key', defaultValue: '', description: 'The requirements jira key.'),
		string(name: 'Config_Git_Url', defaultValue: 'git@gitlab.code.mob.com:pangjj/ios_cd_folders.git', description: 'This job config files.'),
		string(name: 'SourceCode_Git_Url', defaultValue: 'git@gitlab.code.mob.com:mobclub/mobpush-for-ios.git', description: 'Source code git url.'),
		string(name: 'ProjectCode_Git_Url', defaultValue: 'git@gitlab.code.mob.com:androidteam/iosteam/project/mobpush.git', description: 'Project code git url.')
	])])

	stage('Parameter Valid Check') {
		if (isEmpty(params.Jira_Key)) throw new Exception('Jira_Key was required to make sure this operation continue.')
	}

	String config_files_folder = "${WORKSPACE}/../Config_Files/MobPush_Repo/${params.Branch}";
	stage('Checkout Config Files') {
		try {
			String target_folder_path = "/${params.Config_Folder}/*";
			checkout_target_git(params.Config_Git_Url, params.Branch, 'pangjj', target_folder_path, config_files_folder);
		} catch(Exception e) {
			println('Fetch Config Files Failed.');
			throw e;
		}
	}

	stage('Checkout Source Code') {
		try {
			checkout_target_git(params.SourceCode_Git_Url, params.Branch, params.Credential_ID);
		} catch(Exception e) {
			print("Checkout the target branch: ${branch} failed.");
			throw e;
		}
	}

	stage('Organize Config Files') {
		try {
			fileOperations([
				folderDeleteOperation (folderPath: "${config_files_folder}/${params.Config_Folder}/.git"),
				folderCopyOperation (sourceFolderPath: "${config_files_folder}/${params.Config_Folder}", destinationFolderPath: WORKSPACE)
			]);
		} catch(Exception e) {
			println('Organize config files failed.');
			throw e;
		}
	}

	stage('Select Xcode') {
		try {
			sh "echo 123456 | sudo -S xcode-select -s /Applications/${params.Xcode}.app";
		} catch(Exception e) {
			println('Change select xcode failed.')
			throw e
		}
	}

	stage('Configure Fastlane Envrionment') {
		sh 'bundle install && bundle update'
	}

	String project_folder = "${WORKSPACE}/../${params.Job_Name}";
	stage('Checkout Project Source Code') {
		try {
			checkout_target_git(params.ProjectCode_Git_Url, params.Branch, params.Credential_ID, '/*', project_folder);
		} catch(Exception e) {
			print("Checkout the target branch: ${branch} failed.");
			throw e;
		}
	}

	stage('Operational Legitimacy') {
		sh "bundle exec fastlane check_operation_legal job:${params.Job_Name} branch:${params.Branch} version:${params.Version} framework:${params.Framework}"
	}

	stage('Update Podspec File') {
		sh "bundle exec fastlane update_podspec zip:${params.Zip} object:${params.AliYun_Obj} job:${params.Job_Name} branch:${params.Branch} version:${params.Version}"
	}

	stage('Upload Zip File To AliYun') {
		sh "bundle exec fastlane upload_zip_file_to_aliyun job:${params.Job_Name} branch:${params.Branch} version:${params.Version} framework:${params.Framework} zip:${params.Zip} object:${params.AliYun_Obj}"
	}

	stage('Update Pods Trunk') {
		sh "bundle exec fastlane update_pods_trunk_server job:${params.Job_Name} branch:${params.Branch} version:${params.Version} framework:${params.Framework}"
	}

	stage('Add Comments To Jira') {
		sh "bundle exec fastlane add_comments_to_jira job:${params.Job_Name} branch:${params.Branch} version:${params.Version} framework:${params.Framework} zip:${params.Zip} object:${params.AliYun_Obj} jira:${params.Jira_Key}"
	}

	stage('Add Tag To Project') {
		sh "bundle exec fastlane add_tag_to_project_branch job:${params.Job_Name} branch:${params.Branch} version:${params.Version} operator:${params.Credential_ID}"
	}

	stage('Add Tag And Push To Repo') {
		sh "bundle exec fastlane add_and_push_to_repo job:${params.Job_Name} branch:${params.Branch} version:${params.Version} framework:${params.Framework} operator:${params.Credential_ID}"
	}
}

boolean isEmpty(value) { 
	if (value) {
		return false;
	}
	return true;
}

void checkout_target_git(url, branch = 'master', credential_id = '', target_path = '', local_path = null) {
	if (isEmpty(url) || isEmpty(credential_id)) throw new Exception('The required parameters invalid, please check them.');

	if (!local_path) local_path = '.'

	List target_paths = []
	if (target_path) target_paths.add(['path':target_path])

	dir(local_path) {
		checkout([
			$class: 'GitSCM',
			branches: [[name: 'refs/heads/' + branch]],
			doGenerateSubmoduleConfigurations: false,
			extensions: [
				[$class: 'CheckoutOption', timeout: 20],
				[$class: 'CloneOption', depth: 3, noTags: false, reference: '', shallow: true, timeout: 10],
				[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: target_paths]
			],
			userRemoteConfigs: [
				[
					url: url,
					credentialsId: credential_id
				]
			]
		])
	}
}