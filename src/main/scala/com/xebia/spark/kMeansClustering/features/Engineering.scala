package com.xebia.spark.kMeansClustering.features

import org.apache.spark.mllib.linalg.{Vectors, Vector}
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.rdd.RDD


object Engineering {

  def featureEngineering(data : RDD[String]): RDD[LabeledPoint] = {

    data.map(line => {

      val values = line.split('§')
      val label = values(1).toDouble

      val pClass = values(0).toDouble

      val age = values(4) match {
        case "NA" => 28d
        case l => l.toDouble
      }
      val sibsp = values(5).toDouble
      val parch = values(6).toDouble
      val fair = values(8) match {
        case "NA" => 14.45
        case l => l.toDouble
      }

      val numericalData = Array(pClass, age, sibsp, parch, fair)

      LabeledPoint(label, Vectors.dense(numericalData))
    })

  }

}
