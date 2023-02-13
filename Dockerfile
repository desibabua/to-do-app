# Doing multi layer building for compressing docker image

# 1. This step creates build folder.
FROM node:14-alpine
WORKDIR /
COPY . .
RUN yarn install
RUN yarn build

# 2. This step will server the build folder.
FROM node:14-alpine
WORKDIR /
COPY --from=0 /build /
RUN npm install -g serve
ENTRYPOINT [ "serve" ]
CMD [ "-s", "." ,"-l", "3000" ]

# EXPOSE 3000

# docker build -t ayushkr/to-do-app .
# docker run -p 3000:3000 ayushkr/to-do-app