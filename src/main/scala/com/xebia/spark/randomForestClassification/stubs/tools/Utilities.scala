package com.xebia.spark.randomForestClassification.stubs.tools

import org.apache.spark.mllib.evaluation.MulticlassMetrics
import org.apache.spark.mllib.linalg.Matrix
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.tree.model.{DecisionTreeModel, RandomForestModel}
import org.apache.spark.rdd.RDD


object Utilities {
  /**
   * Extract header of a dataset
   * @param rdd A RDD with a header inside
   * @return A tuple2. First element of the tuple is the header. Second element is the data.
   */
  def extractHeader(rdd: RDD[String]): (String, RDD[String]) = {

    // Take the first line (csv schema)
    val schema = rdd.first()

    // Remove first line from first partition only
    (schema, rdd.mapPartitionsWithIndex {
      case (0, l) => l.drop(1)
      case (_, l) => l
    })
  }


  /**
   *
   * @param model A DecisionTreeModel from the method DecisionTree.trainClassifier()
   * @param data the data (a RDD[LabeledPoint])
   * @return A tuple giving the accuracy and the confusion matrix
   */
  def getMetricsDecisionTree(model: DecisionTreeModel, data: RDD[LabeledPoint]): (Double, Matrix) = {

    val predictionsAndLabels = data.map(l => (model.predict(l.features), l.label))

    val metrics: MulticlassMetrics = new MulticlassMetrics(predictionsAndLabels)

    val accuracy = 100d * metrics.precision
    val confusion = metrics.confusionMatrix

    (accuracy, confusion)
  }


  /**
   *
   * @param model A RandomForestModel from the method RandomForest.trainClassifier()
   * @param data the data (a RDD[LabeledPoint])
   * @return A tuple giving the accuracy and the confusion matrix
   */
  def getMetricsRandomForest(model: RandomForestModel, data: RDD[LabeledPoint]): (Double, Matrix) = {

    val predictionsAndLabels = data.map(l => (model.predict(l.features), l.label))

    val metrics: MulticlassMetrics = new MulticlassMetrics(predictionsAndLabels)

    val accuracy = 100d * metrics.precision
    val confusion = metrics.confusionMatrix

    (accuracy, confusion)
  }

}
