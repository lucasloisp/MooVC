//
//  MovieSharing.swift
//  MoViesC
//
//  Created by Lucas Lois on 2/8/21.
//

import Foundation

import MultiPeer

protocol MovieSharingDelegate: AnyObject {
    func receivedFromPeer(movieId: Int)
}

class MovieSharing {

    private enum DataType: UInt32 {
        case movie = 1
    }

    static let shared = MovieSharing()
    private static let serviceType = "moovc"

    weak var delegate: MovieSharingDelegate?

    private let multiPeer: MultiPeer

    private init() {
        self.multiPeer = MultiPeer.instance
    }

    func share(movie: Movie) {
        sendToPeers(object: movie.tmbdId, type: .movie)
    }

    func startSharing() {
        multiPeer.initialize(serviceType: Self.serviceType)
        multiPeer.autoConnect()
        multiPeer.delegate = self
    }

    private func onReceive(movieId: Int) {
        delegate?.receivedFromPeer(movieId: movieId)
    }

    private func sendToPeers(object: Any, type: DataType) {
        multiPeer.stopSearching()

        defer {
            multiPeer.autoConnect()
        }

        multiPeer.send(object: object, type: type.rawValue)
    }
}

extension MovieSharing: MultiPeerDelegate {
    func multiPeer(didReceiveData data: Data, ofType type: UInt32, from peerID: MCPeerID) {
        switch type {
        case DataType.movie.rawValue:
            // swiftlint:disable:next force_cast
            let movieId = data.convert() as! Int
            onReceive(movieId: movieId)
        default:
            break
        }
    }

    func multiPeer(connectedDevicesChanged devices: [String]) {
        print("Connected to \(devices.count) devices")
    }
}
