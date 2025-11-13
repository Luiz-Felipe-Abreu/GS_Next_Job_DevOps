# ==============================================================================
# Dockerfile para Aplicação NextJob (Spring Boot)
# ==============================================================================
# RM: 555197
# Descrição: Container da aplicação Java Spring Boot
# Usando imagem oficial Eclipse Temurin (OpenJDK) - Requisito 9
# ==============================================================================

# ---------- Build stage ----------
FROM eclipse-temurin:17-jdk-alpine AS build
LABEL maintainer="RM555197"
LABEL project="NextJob"
LABEL stage="build"

WORKDIR /app

# Copiar arquivos do Gradle
COPY gradle gradle
COPY gradlew .
COPY settings.gradle .
COPY build.gradle .

# Dar permissão de execução
RUN chmod +x ./gradlew

# Download de dependências (cache layer)
RUN ./gradlew dependencies --no-daemon || true

# Copiar código fonte
COPY src src

# Build da aplicação (sem executar testes para acelerar build)
RUN ./gradlew clean bootJar --no-daemon -x test

# ---------- Runtime stage ----------
FROM eclipse-temurin:17-jre-alpine AS runtime
LABEL maintainer="RM555197"
LABEL project="NextJob"
LABEL stage="runtime"

# Criar usuário não-root para segurança
RUN addgroup -S nextjob && adduser -S nextjob -G nextjob

# Mudar para usuário não-root
USER nextjob

WORKDIR /app

# Porta da aplicação
EXPOSE 8080

# Copiar JAR da etapa de build
COPY --from=build --chown=nextjob:nextjob /app/build/libs/*.jar /app/app.jar

# Healthcheck (desabilitado para simplificar)
# HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
#   CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Variáveis de ambiente (podem ser sobrescritas no ACI)
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENV SPRING_PROFILES_ACTIVE=prod

# Entrypoint
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
