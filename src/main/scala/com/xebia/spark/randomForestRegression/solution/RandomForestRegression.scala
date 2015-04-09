package com.xebia.spark.randomForestRegression.solution


import com.xebia.spark.randomForestRegression.solution.features.Engineering
import com.xebia.spark.randomForestRegression.solution.tools.Utilities._
import org.apache.spark.{SparkContext, SparkConf}


object RandomForestRegression {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("KMeans").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")
    val (header, data) = extractHeader(rawData)

    val cleandedData = Engineering.featureEngineering(data)

    data.take(20).foreach(println)
    cleandedData.foreach(println)

  }




}
