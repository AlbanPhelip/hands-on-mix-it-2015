package com.xebia.spark.kMeansClustering

import com.xebia.spark.kMeansClustering.features.Engineering.featureEngineering
import com.xebia.spark.kMeansClustering.tools.Utilities
import com.xebia.spark.kMeansClustering.tools.Utilities._
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.mllib.clustering.KMeans

object KMeansClusteringSolution {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("KMeans").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Loading data
    val rawData = sc.textFile("./src/main/resources/data_titanic.csv")

    // Parsing Data
    val data = extractHeader(rawData)._2

    // Feature Engineering
    val cleanData = featureEngineering(data)

    // Get the features
    val featuredData = cleanData.map(_.features)

    // Modelling
    val model = KMeans.train(featuredData, 2, 20)

    // Inspect population of each cluster
    val statsPerCluster = Utilities.getStatsPerCluster(model, cleanData)
    statsPerCluster.foreach(println)

  }

}
