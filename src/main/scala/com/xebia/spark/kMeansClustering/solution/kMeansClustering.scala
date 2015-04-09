package com.xebia.spark.kMeansClustering.solution

import com.xebia.spark.kMeansClustering.solution.tools.Utilities.extractHeader
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object kMeansClustering {


  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("SMS_Spam_Classification").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")
    val (header, data) = extractHeader(rawData)

    println(header)


  }

}
