package com.xebia.spark.randomForestClassification.stubs.modelling

import com.xebia.spark.randomForestClassification.stubs.tools.Utilities.getMetricsRandomForest
import org.apache.spark.mllib.regression.LabeledPoint
import org.apache.spark.mllib.tree.{RandomForest, DecisionTree}
import org.apache.spark.mllib.tree.model.{RandomForestModel, DecisionTreeModel}
import org.apache.spark.rdd.RDD


object TreeModelling {


  /**
   * Train a Decision Tree Classifier
   * @param data: RDD[LabeledPoint] - The training set
   * @param categoricalFeaturesInfo: A Map indicating which features are categorical and how many categories they contain
   * @param impurity: The impurity measure to select the best feature for splitting ("entropy" or "gini")
   * @param maxDepth: The maximum depth of each tree
   * @param maxBins: The maximum number of leaves for each tree
   * @return A DecisionTreeClassifier Model, usable to predict new data
   */
  def decisionTreeTrainClassifier(categoricalFeaturesInfo: Map[Int, Int] = Map[Int, Int](),
                                  impurity: String = "entropy",
                                  maxDepth: Int = 2,
                                  maxBins: Int = 12)(data: RDD[LabeledPoint]) : DecisionTreeModel = {
    DecisionTree.trainClassifier(data, 2, categoricalFeaturesInfo, impurity, maxDepth, maxBins)
  }


  /**
   * Train a Random Forest Classifier
   * @param data: RDD[LabeledPoint] - The training set
   * @param categoricalFeaturesInfo: A Map indicating which features are categorical and how many categories they contain
   * @param numTrees: The number of trees to train
   * @param featuresSubsetStrategy: Strategy to select a subset of the features for splitting (use "auto")
   * @param impurity: The impurity measure to select the best feature for splitting ("entropy" or "gini")
   * @param maxDepth: The maximum depth of each tree
   * @param maxBins: The maximum number of leaves for each tree
   * @return A RandomForestClassifier Model, usable to predict new data
   */
  def randomForestTrainClassifier(categoricalFeaturesInfo: Map[Int, Int] = Map[Int, Int](),
                                 numTrees: Int = 10,
                                 featuresSubsetStrategy: String = "auto",
                                 impurity: String = "entropy",
                                 maxDepth: Int = 2,
                                 maxBins: Int = 12)(data: RDD[LabeledPoint]) : RandomForestModel = {
    RandomForest.trainClassifier(data, 2, categoricalFeaturesInfo, numTrees, featuresSubsetStrategy, impurity, maxDepth, maxBins)
  }


  /**
   * Perform a Grid Search to find the best parameters for the Random Forest
   * @param trainSet: RDD[LabeledPoint] - The training set
   * @param valSet: RDD[LabeledPoint] - The validation set
   * @param categoricalFeaturesInfo: A Map indicating which features are categorical and how many categories they contain
   * @param numTreesGrid: The number of trees to train
   * @param featuresSubsetStrategy: Strategy to select a subset of the features for splitting (use "auto")
   * @param impurityGrid: The impurity measure to select the best feature for splitting ("entropy" or "gini")
   * @param maxDepthGrid: The maximum depth of each tree
   * @param maxBinsGrid: The maximum number of leaves for each tree
   * @return The best parameters found, in a tuple.
   */
  def gridSearchRandomForestClassifier(trainSet: RDD[LabeledPoint],
                                       valSet: RDD[LabeledPoint],
                                       categoricalFeaturesInfo: Map[Int, Int] = Map[Int, Int](),
                                       numTreesGrid: Array[Int] = Array(10),
                                       featuresSubsetStrategy: String = "auto",
                                       impurityGrid: Array[String] = Array("entropy"),
                                       maxDepthGrid: Array[Int] = Array(2),
                                       maxBinsGrid: Array[Int] = Array(4)) = {

    val gridSearch =

      for (numTrees <- numTreesGrid;
           impurity <- impurityGrid;
           maxDepth <- maxDepthGrid;
           maxBins <- maxBinsGrid)
        yield {

          // TODO : Train a randomForestTrainClassifier on the train set with the selected parameters

          // TODO : Get the accuracy from getMetricsRandomForest for prediction on the validation set

          // TODO : Create a tuple in the following format :
          // ((numTrees, impurity, maxDepth, maxBins), accuracyVal)
        }

    // TODO : Uncomment the following lines to select the parameters returning the best results
//    val params = gridSearch.sortBy(_._2).reverse(0)._1
//    val numTrees = params._1
//    val impurity = params._2
//    val maxDepth = params._3
//    val maxBins = params._4
//
//    (categoricalFeaturesInfo, numTrees, featuresSubsetStrategy, impurity, maxDepth, maxBins)
  }

}
