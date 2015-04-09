package com.xebia.spark.kMeansClustering.solution

import com.xebia.spark.kMeansClustering.solution.features.Engineering.featureEngineering
import com.xebia.spark.kMeansClustering.solution.tools.Utilities
import com.xebia.spark.kMeansClustering.solution.tools.Utilities.extractHeader
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.mllib.clustering.KMeans
import org.apache.spark.mllib.evaluation.MulticlassMetrics

object kMeansClustering {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("KMeans").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")
    val (header, data) = extractHeader(rawData)

    val cleanData = featureEngineering(data)

    val featuredData = cleanData.map(_._1)
    val labels = cleanData.map(_._2)

    val model = KMeans.train(featuredData, 2, 5)

    val metrics = Utilities.getMetrics(model, featuredData, labels)

    val accuracy = if(metrics.precision > 0.5) 1d - metrics.precision else metrics.precision
    val confusion = metrics.confusionMatrix

    // Print results
    println(s"Confusion Matrix: \n $confusion")
    println(s"Error: $accuracy")



  }

}
