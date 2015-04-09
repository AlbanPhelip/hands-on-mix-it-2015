package com.xebia.spark.kMeansClustering.solution

import com.xebia.spark.kMeansClustering.solution.features.Engineering.featureEngineering
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

    val Array(train, test) = cleanData.randomSplit(Array(0.6, 0.4))

    val model = KMeans.train(train.map(_._1), 2, 10)

    val prediction = model.predict(test.map(_._1))

    val pred = test.map(l => (model.predict(l._1).toDouble, l._2))


    val matrix = new MulticlassMetrics(pred)

    println(matrix.confusionMatrix.toString())
    println(prediction.sum())


  }

}
