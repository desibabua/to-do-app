FROM node:14-alpine
# RUN apk add --no-cache python3 g++ make
WORKDIR /
COPY . .
RUN yarn install
ENTRYPOINT ["npm", "start"]
EXPOSE 3000

# docker build -t ayushkr/to-do-app .
# docker run -p 3000:3000 ayushkr/to-do-app