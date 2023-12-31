//
//  OCRViewModel.swift
//  SickSangHae
//
//  Created by 최효원 on 2023/07/18.
//

import OpenAI
import SwiftUI
import Vision
import VisionKit

// MARK: - Model
struct AIChat: Codable {
    let datetime: String
    var issue: String
    var answer: String?
    var isResponse: Bool = false
    var model: String
    var userAvatarUrl: String
}

public enum Environments {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let chatToken = "CHAT_GPT_TOKEN"
            static let chatOrganization = "CHAT_GPT_ORGANIZATIONIDENTIFIER"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let chatTokenkey: String = {
        guard let chatTokenstring = Environments.infoDictionary[Keys.Plist.chatToken] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return chatTokenstring
    }()

    static let chatOrganizationkey: String = {
        guard let chatOrganizationkey = Environments.infoDictionary[Keys.Plist.chatOrganization] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return chatOrganizationkey
    }()
}

class OCRViewModel: ObservableObject {
    @Published var OCRString: String?
    @Published var textObservations: [VNRecognizedTextObservation] = []
    let chatToken = Environments.chatTokenkey
    let chatOrganization = Environments.chatOrganizationkey
    var gptAnswer = Dictionary<String, [Any]>()
    var gptPrompt = ""

    //이미지 분석 메소드
    @MainActor
    func recognizeText(image: UIImage) {
        guard let image = image.cgImage else {
            fatalError("이미지 오류")
        }

        let transform = CGAffineTransform.identity.scaledBy(x: CGFloat(image.width), y: CGFloat(image.height))
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let result = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }

            let text = result.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            self?.OCRString = text
            print(text)

            let requestArr = result.compactMap { $0.topCandidates(1).first?.string }
            self!.gptPrompt = requestArr.joined(separator: " ")

            // MARK: GPT 연결하는 부분
            print("Request Results: \(requestArr.joined(separator: " "))")
            print("Request Results: \(requestArr)")

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }

            var textBoundingBoxes: [CGRect] = []
            for observation in observations {
                let transformedRect = observation.boundingBox.applying(transform)
                textBoundingBoxes.append(transformedRect)
            }

            DispatchQueue.main.async {
                self?.textObservations = observations
            }
        }

        if #available(iOS 16.0, *) {
            request.revision = VNRecognizeTextRequestRevision3
            request.recognitionLanguages = ["ko-KR"]
        } else {
            request.recognitionLanguages = ["en-US"]
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        do {
            print(try request.supportedRecognitionLanguages())
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @MainActor
    func queryGPT(prompts: String, dispatchGroup: DispatchGroup, completion: @escaping (String) -> Void) {
        let configuration = OpenAI.Configuration(token: chatToken, organizationIdentifier: chatOrganization, timeoutInterval: 60.0)
        let openAI = OpenAI(configuration: configuration)
        let customPrompt = prompts + "\n 이거를 딕셔너리로 정리해. 다음과 같은 포맷으로 줘야해. {\"상품명\": [], \"수량\": [], \"금액\": []}. 특수문자는 모두 제거해. 상품명에는 수량, 금액을 제거해.  수량, 금액은 Int형으로 되어있어야 해. 상품명, 수량, 금액 중에 비어 있는게 있으면 1을 추가해서 넣어. null은 모두 1로 바꿔. 그리고 상품명 value의 array size와 수량, 금액 value의 array size가 다르면 수량, 금액 value의  array size가 같아지도록 1을 추가해. 오직 딕셔너리만 응답해야 돼. 다른 말 하지마."

        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: customPrompt)])
        
        openAI.chatsStream(query: query) { partialResult in
            print("GPT data:")
            switch partialResult {
            case .success(let result):
                if let res = result.choices.first?.delta.content{
                    DispatchQueue.main.async {
                        completion(res)
                    }
                }
            case .failure(let error):
                print(error)
                let errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    completion(errorMessage)
                }
            }
        } completion: { error in
            print(error ?? "Unknown Error.")
            dispatchGroup.leave()
            if let errorMessage = error?.localizedDescription {
                DispatchQueue.main.async {
                    completion(errorMessage)
                }
            }
        }
    }

    func convertToDictionary(text: String) -> [String: [Any]]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]]
            } catch {
                return ["상품명": ["스캔이 올바르지 않아요"], "단가": [0], "수량": [0], "금액": [0]]
            }
        }
        return nil
    }
}

