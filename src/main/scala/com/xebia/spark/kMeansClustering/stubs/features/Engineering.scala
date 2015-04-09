package com.xebia.spark.kMeansClustering.stubs.features

import org.apache.spark.mllib.linalg.{Vectors, Vector}
import org.apache.spark.rdd.RDD


object Engineering {

  def featureEngineering(data : RDD[String]): RDD[(Vector, Double)] = {

   data.map(line => {

      val values = line.split('§')
      val label = values(1).toDouble

      val numericalData = Array(values(0), values(4), values(5), values(6), values(8)).map {
        case "NA" => 0d
        case l => l.toDouble
      }

     (Vectors.dense(numericalData), label)
    })

  }

}
