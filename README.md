## Mybuntu

This docker image allows you to start coding with Le Wagon setup in just a few minutes.
It follows all the setup that you need from the [official Wagon instructions](https://github.com/lewagon/setup)

## How to use

1. Clone this repo and cd into it 

2. Look into the Dockerfile. You need to change line 49 to put your own personal info. If you are in China, there are also some lines you need to uncomment for better performance. 

3. When you are done, just type the following commands:


        docker-compose up -d
        docker exec -ti mybuntu /bin/zsh 

That's all. You can now code inside this space and clone all your repos here - you have all you need: Ubuntu, Ruby, rbenv, Node, npm, etc.