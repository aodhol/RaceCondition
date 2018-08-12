import Foundation

//class DecodeOperation<T: Decodable>: AsyncOperation {
//
//    var data: Data? = nil
//    var decoded: T? = nil
//
//    override func workItem() {
//        do {
//            guard let data = data else {
//                markFinished()
//                return
//            }
//            self.decoded = try JSONDecoder().decode(T.self, from: data)
//        } catch let error {
//            print("ERROR: \(error.localizedDescription)")
//        }
//    }
//}
//
//class RequestOperation: AsyncOperation {
//
//    private var URLSessionTaksOperationKVOContext = 0
//
//    let request: URLRequest
//    var task: URLSessionTask?
//
//    var data: Data?
//
//    init(request: URLRequest) {
//        self.request = request
//    }
//
//    override func workItem() {
//        task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//            guard let data = data,
//                let httpUrlResponse = response as? HTTPURLResponse,
//                let mimeType = httpUrlResponse.mimeType,
//                mimeType == "application/json",
//                httpUrlResponse.statusCode == 200,
//                error == nil else {
//                    print("ERROR: \(error?.localizedDescription ?? "")")
//                    return
//            }
//            self?.data = data
//        }
//        task?.resume()
//    }
//}
