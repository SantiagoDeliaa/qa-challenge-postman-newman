# Usa la imagen oficial de Newman como base
FROM postman/newman:alpine

# Instala el reporter HTML una sola vez
RUN npm install -g newman-reporter-html
