FROM bitnami/java:1.8 as builder
WORKDIR /app
RUN wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war

FROM bitnami/java:1.8-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 8080
CMD ["java", "-jar", "jenkins.war"]
