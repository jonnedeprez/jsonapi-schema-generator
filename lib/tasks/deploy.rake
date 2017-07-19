task :deploy do
  sh 'git checkout production'
  sh 'git merge master -m "Merging master for deployment"'

  sh 'cd app/frontend && ember build --environment=production'
  sh 'cd public && find -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 rm -R'
  # sh "cd app/frontend/dist && sed -ie 's/assets/\\/assets/g' index.html && mv -f * ../../../public"
  sh "cd app/frontend/dist && mv -f * ../../../public"

  unless `git status` =~ /nothing to commit, working directory clean/
    sh 'git add -A'
    sh 'git commit -m "Asset compilation for deployment"'
  end

  sh 'git push heroku production:master'

  sh 'git checkout -'
end