@REM spark-notebook launcher script
@REM
@REM Environment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM SPARK_NOTEBOOK_config.txt found in the SPARK_NOTEBOOK_HOME.
@setlocal enabledelayedexpansion

@echo off

if "%SPARK_NOTEBOOK_HOME%"=="" set "SPARK_NOTEBOOK_HOME=%~dp0\\.."
set ERROR_CODE=0

set "APP_LIB_DIR=%SPARK_NOTEBOOK_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (!cmdcmdline!) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%SPARK_NOTEBOOK_HOME%\SPARK_NOTEBOOK_config.txt"
set CFG_OPTS=
if exist %CFG_FILE% (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
  )
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==java set JAVAINSTALLED=1
  if %%~j==openjdk set JAVAINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running spark-notebook.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "!_JAVA_OPTS!"=="" set _JAVA_OPTS=!CFG_OPTS!

rem We keep in _JAVA_PARAMS all -J-prefixed and -D-prefixed arguments
rem "-J" is stripped, "-D" is left as is, and everything is appended to JAVA_OPTS
set _JAVA_PARAMS=
set _APP_ARGS=

:param_loop
call set _PARAM1=%%1
set "_TEST_PARAM=%~1"

if ["!_PARAM1!"]==[""] goto param_afterloop


rem ignore arguments that do not start with '-'
if "%_TEST_PARAM:~0,1%"=="-" goto param_java_check
set _APP_ARGS=!_APP_ARGS! !_PARAM1!
shift
goto param_loop

:param_java_check
if "!_TEST_PARAM:~0,2!"=="-J" (
  rem strip -J prefix
  set _JAVA_PARAMS=!_JAVA_PARAMS! !_TEST_PARAM:~2!
  shift
  goto param_loop
)

if "!_TEST_PARAM:~0,2!"=="-D" (
  rem test if this was double-quoted property "-Dprop=42"
  for /F "delims== tokens=1,*" %%G in ("!_TEST_PARAM!") DO (
    if not ["%%H"] == [""] (
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
    ) else if [%2] neq [] (
      rem it was a normal property: -Dprop=42 or -Drop="42"
      call set _PARAM1=%%1=%%2
      set _JAVA_PARAMS=!_JAVA_PARAMS! !_PARAM1!
      shift
    )
  )
) else (
  set _APP_ARGS=!_APP_ARGS! !_PARAM1!
)
shift
goto param_loop
:param_afterloop

set _JAVA_OPTS=!_JAVA_OPTS! !_JAVA_PARAMS!
:run
 
set "APP_CLASSPATH=%APP_LIB_DIR%\noootsab.spark-notebook-0.2.0-spark-1.2.0-hadoop-1.0.4.jar;%APP_LIB_DIR%\subprocess.subprocess-0.2.0-spark-1.2.0-hadoop-1.0.4.jar;%APP_LIB_DIR%\observable.observable-0.2.0-spark-1.2.0-hadoop-1.0.4.jar;%APP_LIB_DIR%\common.common-0.2.0-spark-1.2.0-hadoop-1.0.4.jar;%APP_LIB_DIR%\kernel.kernel-0.2.0-spark-1.2.0-hadoop-1.0.4.jar;%APP_LIB_DIR%\spark-repl_2.10-1.2.0-notebook.jar;%APP_LIB_DIR%\org.scala-lang.scala-compiler-2.10.4.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.10.4.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.10.4.jar;%APP_LIB_DIR%\com.typesafe.play.play_2.10-2.3.7.jar;%APP_LIB_DIR%\com.typesafe.play.build-link-2.3.7.jar;%APP_LIB_DIR%\com.typesafe.play.play-exceptions-2.3.7.jar;%APP_LIB_DIR%\org.javassist.javassist-3.18.2-GA.jar;%APP_LIB_DIR%\org.scala-stm.scala-stm_2.10-0.7.jar;%APP_LIB_DIR%\com.typesafe.config-1.2.1.jar;%APP_LIB_DIR%\joda-time.joda-time-2.3.jar;%APP_LIB_DIR%\org.joda.joda-convert-1.6.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.3.2.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.3.2.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.3.2.jar;%APP_LIB_DIR%\com.typesafe.play.twirl-api_2.10-1.0.2.jar;%APP_LIB_DIR%\io.netty.netty-3.9.3.Final.jar;%APP_LIB_DIR%\com.typesafe.netty.netty-http-pipelining-1.1.2.jar;%APP_LIB_DIR%\org.slf4j.jul-to-slf4j-1.7.6.jar;%APP_LIB_DIR%\org.slf4j.jcl-over-slf4j-1.7.6.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.1.1.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.1.1.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.9.jar;%APP_LIB_DIR%\xerces.xercesImpl-2.11.0.jar;%APP_LIB_DIR%\xml-apis.xml-apis-1.4.01.jar;%APP_LIB_DIR%\javax.transaction.jta-1.1.jar;%APP_LIB_DIR%\org.spark-project.akka.akka-actor_2.10-2.3.4-spark.jar;%APP_LIB_DIR%\org.spark-project.akka.akka-remote_2.10-2.3.4-spark.jar;%APP_LIB_DIR%\org.spark-project.protobuf.protobuf-java-2.5.0-spark.jar;%APP_LIB_DIR%\org.uncommons.maths.uncommons-maths-1.2.2a.jar;%APP_LIB_DIR%\org.spark-project.akka.akka-slf4j_2.10-2.3.4-spark.jar;%APP_LIB_DIR%\org.apache.commons.commons-exec-1.2.jar;%APP_LIB_DIR%\log4j.log4j-1.2.16.jar;%APP_LIB_DIR%\org.apache.spark.spark-sql_2.10-1.2.0.jar;%APP_LIB_DIR%\org.apache.spark.spark-core_2.10-1.2.0.jar;%APP_LIB_DIR%\com.twitter.chill_2.10-0.5.0.jar;%APP_LIB_DIR%\com.twitter.chill-java-0.5.0.jar;%APP_LIB_DIR%\com.esotericsoftware.kryo.kryo-2.21.jar;%APP_LIB_DIR%\com.esotericsoftware.reflectasm.reflectasm-1.07-shaded.jar;%APP_LIB_DIR%\com.esotericsoftware.minlog.minlog-1.2.jar;%APP_LIB_DIR%\org.objenesis.objenesis-1.2.jar;%APP_LIB_DIR%\org.apache.spark.spark-network-common_2.10-1.2.0.jar;%APP_LIB_DIR%\io.netty.netty-all-4.0.23.Final.jar;%APP_LIB_DIR%\org.spark-project.spark.unused-1.0.0.jar;%APP_LIB_DIR%\org.apache.spark.spark-network-shuffle_2.10-1.2.0.jar;%APP_LIB_DIR%\net.java.dev.jets3t.jets3t-0.7.1.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.1.1.jar;%APP_LIB_DIR%\commons-httpclient.commons-httpclient-3.1.jar;%APP_LIB_DIR%\org.apache.curator.curator-recipes-2.4.0.jar;%APP_LIB_DIR%\org.apache.curator.curator-framework-2.4.0.jar;%APP_LIB_DIR%\org.apache.curator.curator-client-2.4.0.jar;%APP_LIB_DIR%\org.apache.zookeeper.zookeeper-3.4.5.jar;%APP_LIB_DIR%\jline.jline-0.9.94.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-plus-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.orbit.javax.transaction-1.1.1.v201105210645.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-webapp-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-xml-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-util-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-servlet-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-security-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-server-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.orbit.javax.servlet-3.0.0.v201112011016.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-continuation-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-http-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-io-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.jetty-jndi-8.1.14.v20131031.jar;%APP_LIB_DIR%\org.eclipse.jetty.orbit.javax.mail.glassfish-1.4.1.v201005082020.jar;%APP_LIB_DIR%\org.eclipse.jetty.orbit.javax.activation-1.1.0.v201105071233.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.3.2.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-1.3.9.jar;%APP_LIB_DIR%\com.ning.compress-lzf-1.0.0.jar;%APP_LIB_DIR%\org.xerial.snappy.snappy-java-1.1.1.6.jar;%APP_LIB_DIR%\net.jpountz.lz4.lz4-1.2.0.jar;%APP_LIB_DIR%\org.roaringbitmap.RoaringBitmap-0.4.5.jar;%APP_LIB_DIR%\commons-net.commons-net-2.2.jar;%APP_LIB_DIR%\org.json4s.json4s-jackson_2.10-3.2.10.jar;%APP_LIB_DIR%\org.json4s.json4s-core_2.10-3.2.10.jar;%APP_LIB_DIR%\org.json4s.json4s-ast_2.10-3.2.10.jar;%APP_LIB_DIR%\com.thoughtworks.paranamer.paranamer-2.6.jar;%APP_LIB_DIR%\org.scala-lang.scalap-2.10.0.jar;%APP_LIB_DIR%\org.apache.mesos.mesos-0.18.1-shaded-protobuf.jar;%APP_LIB_DIR%\com.clearspring.analytics.stream-2.7.0.jar;%APP_LIB_DIR%\com.codahale.metrics.metrics-core-3.0.0.jar;%APP_LIB_DIR%\com.codahale.metrics.metrics-jvm-3.0.0.jar;%APP_LIB_DIR%\com.codahale.metrics.metrics-json-3.0.0.jar;%APP_LIB_DIR%\com.codahale.metrics.metrics-graphite-3.0.0.jar;%APP_LIB_DIR%\org.tachyonproject.tachyon-client-0.5.0.jar;%APP_LIB_DIR%\org.tachyonproject.tachyon-0.5.0.jar;%APP_LIB_DIR%\commons-io.commons-io-2.4.jar;%APP_LIB_DIR%\org.spark-project.pyrolite-2.0.1.jar;%APP_LIB_DIR%\net.sf.py4j.py4j-0.8.2.1.jar;%APP_LIB_DIR%\org.apache.spark.spark-catalyst_2.10-1.2.0.jar;%APP_LIB_DIR%\org.scalamacros.quasiquotes_2.10-2.0.1.jar;%APP_LIB_DIR%\com.twitter.parquet-column-1.6.0rc3.jar;%APP_LIB_DIR%\com.twitter.parquet-common-1.6.0rc3.jar;%APP_LIB_DIR%\com.twitter.parquet-encoding-1.6.0rc3.jar;%APP_LIB_DIR%\com.twitter.parquet-generator-1.6.0rc3.jar;%APP_LIB_DIR%\com.twitter.parquet-hadoop-1.6.0rc3.jar;%APP_LIB_DIR%\com.twitter.parquet-format-2.2.0-rc1.jar;%APP_LIB_DIR%\com.twitter.parquet-jackson-1.6.0rc3.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-mapper-asl-1.9.11.jar;%APP_LIB_DIR%\org.codehaus.jackson.jackson-core-asl-1.9.11.jar;%APP_LIB_DIR%\org.apache.hadoop.hadoop-client-1.0.4.jar;%APP_LIB_DIR%\org.apache.hadoop.hadoop-core-1.0.4.jar;%APP_LIB_DIR%\xmlenc.xmlenc-0.52.jar;%APP_LIB_DIR%\org.apache.commons.commons-math-2.1.jar;%APP_LIB_DIR%\commons-configuration.commons-configuration-1.6.jar;%APP_LIB_DIR%\commons-collections.commons-collections-3.2.1.jar;%APP_LIB_DIR%\commons-digester.commons-digester-1.8.jar;%APP_LIB_DIR%\commons-beanutils.commons-beanutils-1.7.0.jar;%APP_LIB_DIR%\commons-beanutils.commons-beanutils-core-1.8.0.jar;%APP_LIB_DIR%\commons-el.commons-el-1.0.jar;%APP_LIB_DIR%\hsqldb.hsqldb-1.8.0.10.jar;%APP_LIB_DIR%\oro.oro-2.0.8.jar;%APP_LIB_DIR%\org.slf4j.slf4j-log4j12-1.7.7.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.7.jar;%APP_LIB_DIR%\io.reactivex.rxscala_2.10-0.22.0.jar;%APP_LIB_DIR%\io.reactivex.rxjava-1.0.0-rc.5.jar;%APP_LIB_DIR%\org.scalaz.scalaz-core_2.10-7.0.6.jar;%APP_LIB_DIR%\com.jcabi.jcabi-aether-0.10.1.jar;%APP_LIB_DIR%\com.jcabi.jcabi-aspects-0.18.jar;%APP_LIB_DIR%\com.jcabi.jcabi-log-0.14.3.jar;%APP_LIB_DIR%\org.aspectj.aspectjrt-1.8.2.jar;%APP_LIB_DIR%\javax.validation.validation-api-1.1.0.Final.jar;%APP_LIB_DIR%\org.kuali.maven.wagons.maven-s3-wagon-1.1.20.jar;%APP_LIB_DIR%\org.kuali.common.kuali-s3-1.0.1.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-1.4.2.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.1.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.1.jar;%APP_LIB_DIR%\org.kuali.common.kuali-threads-1.0.9.jar;%APP_LIB_DIR%\commons-lang.commons-lang-2.6.jar;%APP_LIB_DIR%\org.springframework.spring-core-3.1.2.RELEASE.jar;%APP_LIB_DIR%\org.apache.maven.wagon.wagon-provider-api-2.4.jar;%APP_LIB_DIR%\org.codehaus.plexus.plexus-utils-3.0.8.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-api-1.13.1.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-spi-1.13.1.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-util-1.13.1.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-connector-file-1.13.1.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-connector-asynchttpclient-1.13.1.jar;%APP_LIB_DIR%\com.ning.async-http-client-1.6.5.jar;%APP_LIB_DIR%\org.jboss.netty.netty-3.2.5.Final.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-connector-wagon-1.13.1.jar;%APP_LIB_DIR%\org.codehaus.plexus.plexus-classworlds-2.4.jar;%APP_LIB_DIR%\org.codehaus.plexus.plexus-component-annotations-1.5.5.jar;%APP_LIB_DIR%\org.sonatype.aether.aether-impl-1.13.1.jar;%APP_LIB_DIR%\org.apache.maven.maven-aether-provider-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.maven-model-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.maven-model-builder-3.0.5.jar;%APP_LIB_DIR%\org.codehaus.plexus.plexus-interpolation-1.14.jar;%APP_LIB_DIR%\org.apache.maven.maven-repository-metadata-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.maven-artifact-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.shared.maven-dependency-tree-2.1.jar;%APP_LIB_DIR%\org.eclipse.aether.aether-util-0.9.0.M2.jar;%APP_LIB_DIR%\org.hibernate.hibernate-validator-5.1.2.Final.jar;%APP_LIB_DIR%\org.jboss.logging.jboss-logging-3.1.3.GA.jar;%APP_LIB_DIR%\com.fasterxml.classmate-1.0.0.jar;%APP_LIB_DIR%\org.apache.maven.maven-core-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.maven-settings-3.0.5.jar;%APP_LIB_DIR%\org.apache.maven.maven-settings-builder-3.0.5.jar;%APP_LIB_DIR%\org.sonatype.plexus.plexus-sec-dispatcher-1.3.jar;%APP_LIB_DIR%\org.sonatype.plexus.plexus-cipher-1.7.jar;%APP_LIB_DIR%\org.apache.maven.maven-plugin-api-3.0.5.jar;%APP_LIB_DIR%\org.sonatype.sisu.sisu-inject-plexus-2.3.0.jar;%APP_LIB_DIR%\org.sonatype.sisu.sisu-inject-bean-2.3.0.jar;%APP_LIB_DIR%\org.sonatype.sisu.sisu-guice-3.1.0-no_aop.jar;%APP_LIB_DIR%\org.sonatype.sisu.sisu-guava-0.9.9.jar;%APP_LIB_DIR%\io.continuum.bokeh.bokeh_2.10-0.2.jar;%APP_LIB_DIR%\io.continuum.bokeh.core_2.10-0.2.jar;%APP_LIB_DIR%\com.typesafe.play.play-json_2.10-2.4.0-M1.jar;%APP_LIB_DIR%\com.typesafe.play.play-iteratees_2.10-2.4.0-M1.jar;%APP_LIB_DIR%\com.typesafe.play.play-functional_2.10-2.4.0-M1.jar;%APP_LIB_DIR%\com.typesafe.play.play-datacommons_2.10-2.4.0-M1.jar;%APP_LIB_DIR%\io.continuum.bokeh.bokehjs_2.10-0.2.jar;%APP_LIB_DIR%\com.github.scala-incubator.io.scala-io-core_2.10-0.4.3.jar;%APP_LIB_DIR%\com.github.scala-incubator.io.scala-io-file_2.10-0.4.3.jar;%APP_LIB_DIR%\org.scalanlp.breeze_2.10-0.8.1.jar;%APP_LIB_DIR%\org.scalanlp.breeze-macros_2.10-0.3.1.jar;%APP_LIB_DIR%\com.github.fommil.netlib.core-1.1.2.jar;%APP_LIB_DIR%\net.sourceforge.f2j.arpack_combined_all-0.1.jar;%APP_LIB_DIR%\net.sourceforge.f2j.arpack_combined_all-0.1-javadoc.jar;%APP_LIB_DIR%\net.sf.opencsv.opencsv-2.3.jar;%APP_LIB_DIR%\com.github.rwl.jtransforms-2.4.0.jar;%APP_LIB_DIR%\junit.junit-4.8.2.jar;%APP_LIB_DIR%\org.apache.commons.commons-math3-3.2.jar;%APP_LIB_DIR%\org.spire-math.spire_2.10-0.7.4.jar;%APP_LIB_DIR%\org.spire-math.spire-macros_2.10-0.7.4.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging-slf4j_2.10-2.1.2.jar;%APP_LIB_DIR%\com.typesafe.scala-logging.scala-logging-api_2.10-2.1.2.jar;%APP_LIB_DIR%\com.quantifind.wisp_2.10-0.0.2.jar;%APP_LIB_DIR%\net.databinder.unfiltered-filter_2.10-0.8.3.jar;%APP_LIB_DIR%\net.databinder.unfiltered_2.10-0.8.3.jar;%APP_LIB_DIR%\net.databinder.unfiltered-util_2.10-0.8.3.jar;%APP_LIB_DIR%\net.databinder.unfiltered-jetty_2.10-0.8.3.jar;%APP_LIB_DIR%\com.quantifind.sumac_2.10-0.3.0.jar;%APP_LIB_DIR%\org.scala-lang.jline-2.10.4.jar;%APP_LIB_DIR%\org.fusesource.jansi.jansi-1.4.jar;%APP_LIB_DIR%\com.typesafe.play.play-jdbc_2.10-2.3.7.jar;%APP_LIB_DIR%\com.jolbox.bonecp-0.8.0.RELEASE.jar;%APP_LIB_DIR%\com.google.guava.guava-15.0.jar;%APP_LIB_DIR%\com.h2database.h2-1.3.175.jar;%APP_LIB_DIR%\tyrex.tyrex-1.0.1.jar;%APP_LIB_DIR%\com.typesafe.play.anorm_2.10-2.3.7.jar;%APP_LIB_DIR%\com.jsuereth.scala-arm_2.10-1.4.jar;%APP_LIB_DIR%\com.typesafe.play.play-cache_2.10-2.3.7.jar;%APP_LIB_DIR%\net.sf.ehcache.ehcache-core-2.6.8.jar;%APP_LIB_DIR%\noootsab.spark-notebook-0.2.0-spark-1.2.0-hadoop-1.0.4-assets.jar"
set "APP_MAIN_CLASS=play.core.server.NettyServer"

rem Call the application and pass all arguments unchanged.
"%_JAVACMD%" !_JAVA_OPTS! !SPARK_NOTEBOOK_OPTS! -cp "%APP_CLASSPATH%" %APP_MAIN_CLASS% !_APP_ARGS!
if ERRORLEVEL 1 goto error
goto end

:error
set ERROR_CODE=1

:end

@endlocal

exit /B %ERROR_CODE%
