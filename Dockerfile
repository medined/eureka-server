# Run-time image that makes the final image
FROM gcr.io/distroless/java:11
COPY app.jar /app/app.jar

EXPOSE 8761

# When using distroless, entrypoint must be in vector form.
ENTRYPOINT ["java","-jar","/app/app.jar"]
