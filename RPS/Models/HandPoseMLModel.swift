import Foundation
import CoreML

final class HandPoseMLModel: NSObject, Identifiable {
    let name: String
    let mlModel: MLModel
    let url: URL
    
    private var classLabels: [Any] {
        mlModel.modelDescription.classLabels ?? []
    }

    init(name: String, mlModel: MLModel, url: URL) {
        self.name = name
        self.mlModel = mlModel
        self.url = url
    }

    func predict(poses: HandPoseInput) throws -> HandPoseOutput? {
        let features = try mlModel.prediction(from: poses)
        let output = HandPoseOutput(features: features)
        return output
    }
}

extension HandPoseMLModel: @unchecked Sendable {}

class HandPoseInput {
    var poses: MLMultiArray
    
    init(poses: MLMultiArray) {
        self.poses = poses
    }
}

extension HandPoseInput: MLFeatureProvider {
    var featureNames: Set<String> { ["poses"] }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "poses" {
            return MLFeatureValue(multiArray: poses)
        }
        return nil
    }
}

class HandPoseOutput: @unchecked Sendable {
    let provider : MLFeatureProvider

    var labelProbabilities: [String: Double] {
        let featureValue = provider.featureValue(for: "labelProbabilities")
        return featureValue?.dictionaryValue as? [String : Double] ?? [:]
    }

    var label: String {
        provider.featureValue(for: "label")?.stringValue ?? ""
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

extension HandPoseOutput: MLFeatureProvider {
    var featureNames: Set<String> {
        provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }
}
