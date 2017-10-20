node {
  withEnv([
    "PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH",
    "RBENV_SHELL=sh"
   ]) {

     stage('Preparation') { // for display purposes
       // Get some code from a GitHub repository
       git 'https://github.com/lostapathy/simple_report.git'
     }
     stage('Build') {
       sh "bundle install"
     }
     stage('test') {
       sh "bundle exec rake test"
    }
  }
}
