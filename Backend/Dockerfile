# ---------- Build Stage ----------
FROM maven:3.9.9-eclipse-temurin-21 AS builder

# 1. Set up the working directory
WORKDIR /app

# 2. Copy only the dependency file first
COPY pom.xml .

# 3. Download dependencies (cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# 4. Copy the actual source code
COPY src ./src

# 5. Build the application
RUN mvn package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]