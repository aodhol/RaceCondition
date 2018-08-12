import Foundation
import PlaygroundSupport

class DecodeOperation<T: Decodable>: AsyncOperation {

    var data: Data? = nil
    var decoded: T? = nil

    override func workItem() {
        print("starting decode op")
        do {
            guard let data = data else {
                print("data not set")
                markFinished()
                return
            }
            print("decoding: \(data)")
            self.decoded = try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
        }
        self.markFinished()
    }
}

class RequestOperation: AsyncOperation {

    private var URLSessionTaksOperationKVOContext = 0

    let request: URLRequest
    var task: URLSessionTask?

    var data: Data?

    init(request: URLRequest) {
        self.request = request
    }

    override func workItem() {
        print("starting request op")
        task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data,
                let httpUrlResponse = response as? HTTPURLResponse,
                let mimeType = httpUrlResponse.mimeType,
                mimeType == "application/json",
                httpUrlResponse.statusCode == 200,
                error == nil else {
                    print("ERROR: \(error?.localizedDescription ?? "")")
                    return
            }
            print("request complete")
            self?.data = data
            self?.markFinished()
        }
        task?.resume()
    }
}

let queue = OperationQueue()

// Nested because the actual user is under a 'data' key in the JSON :(
struct UserData: Decodable {
    struct User: Decodable {
        let first_name: String
    }
    let data: User
}

func fetchStuff(completion: (_ response: UserData.User?) -> Void) {

    let request = RequestOperation(request: URLRequest(url: URL(string: "https://reqres.in/api/users/2")!))
    let decode = DecodeOperation<UserData>()

    let adapter = BlockOperation() { [unowned decode, unowned request] in
        print("in adapter operation setting data with bytes: \(request.data?.count ?? 0)")
        decode.data = request.data
    }

    adapter.addDependency(request)
    decode.addDependency(adapter)

    // queue.maxConcurrentOperationCount = 1
    queue.addOperations([request, adapter, decode], waitUntilFinished: true)

    completion(decode.decoded?.data)
}

fetchStuff { (user) in
    print("User: \(user?.first_name ?? "empty")")
}

PlaygroundPage.current.needsIndefiniteExecution = true
