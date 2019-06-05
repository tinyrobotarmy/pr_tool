# PrTool

PrTool is a small phoenix app with a react front end using react-vis to graph and visualise information
about Pull Requests in your Github repository.

## Install
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`

After you have istalled it using the commands above you will need to use the mix task to pull in the details about
your repo's pull request simply use:

`mix load <repo_name>`

follow the username / password prompts and PrTool will download all your Pull Request info. You can then go to
the web UI to look at the details.

## Start your Phoenix server
* Start Phoenix endpoint with `mix phx.server`

navigate to `http://localhost:4000` to see a list of git repos you have loaded Pull Request data for
click on the Repo you are interested in to see details avisualisation about Pull Requests for that
Repo


## TODO
* Add a UI for loading git repo
* Add a UI for cleaning old data
* Ensure that all PR data is removed before repo is loaded a second time
* Improve loading PRs so that future loads only add PRs that have changed