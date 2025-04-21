# 第一阶段：构建JAR
FROM maven:3.8.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B  # 提前下载依赖利用缓存
COPY src ./src
RUN mvn package -DskipTests      # 构建可执行JAR,跳过测试

# 第二阶段：最小化运行时镜像
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]