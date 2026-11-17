# Stage 1: Build mã nguồn
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY . .
RUN ./gradlew bootJar

# Stage 2: Runtime
# Chỉ dùng JRE (không có javac, gradle, mã nguồn) → image nhỏ và an toàn hơn
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Chỉ lấy file .jar đã build từ stage "builder", bỏ lại toàn bộ mã nguồn & cache Gradle
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
