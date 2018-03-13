# kubernetes-docker-compose-experiment
This project is an experiment of how to develop a Node.js web app with `docker-compose` and `kubernetes`.

# Requirements
Ensure you have these programs installed on your machine
- `make`
- `docker 17.12.0-ce-mac55 (23011)`
- `kubectl 1.9.3`
- `minikube 0.25.0`

# Local development with docker-compose
- `make up` to boot up containers.
- `make down` to bring down containers.
- `make ssh` to login to `ddn-app` container.
- `make clean-db` to remove `pgdata-development` and `pgdata-test` persistent volumes for postgres database.

First use `make up` to bring up containers and `make ssh` to login `ddn-app` where our node app is located, and `yarn run seed` for database seeding. Finally use `yarn run dev` to fire up the server with nodemon in watching mode.

Open `https://localhost` for nginx routed path or `http://localhost:8080` for direct connection with node app.

Try to edit `app.js` or `index.js` files. The change should be reflected both in terminal where you run `yarn run dev` and the browser.

# Play with kubernetes
- `make minikube` to setup a minikube.
- `make minikube-detete` to shutdown the minikube.
- `make kube` to start deployments with kubernetes.
- `make kube-migrate` to start migration and seeding for database.

To start kubernetes advanture on you local machine, first use `make minikube` to prepare the minikube machine and setup necessary things, and then use `make kube` to make an deployment. The last step is `make kube-migrate` for migration and seeding.

Once the commands above are done use `minikube ip` to lookup the IP of the minikube machine. Open that IP in browser and you should be able to see our web app response via nginx proxy.

Pay attention to the `host` in JSON response. We fired up 2 pods of our node app. Since we use nginx ingress routing for us, refresh the browser should make `host` change for each time.
