# syntax=docker/dockerfile:1

FROM node:lts-alpine
WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfil --production

# Pour l'instant on utilise root user mais apres on peut creer un user spécifique pour cet application
COPY . .

CMD ["node", "src/index.js"]

EXPOSE 3000 
