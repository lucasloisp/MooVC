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
    func connectedToCount(peerCount: Int)
}

class MovieSharing {

    private enum DataType: UInt32 {
        case movie = 1
    }

    static let shared = MovieSharing()
    private static let serviceType = "moovc"

    weak var delegate: MovieSharingDelegate?

    var isInitialized: Bool { _isInitialized }
    private let multiPeer: MultiPeer
    private var _isInitialized: Bool = false

    private init() {
        self.multiPeer = MultiPeer.instance
    }

    func share(movie: Movie) {
        delegate?.receivedFromPeer(movieId: movie.tmbdId)
        sendToPeers(object: movie.tmbdId, type: .movie)
    }

    func startSharing() {
        multiPeer.initialize(serviceType: Self.serviceType)
        multiPeer.autoConnect()
        multiPeer.delegate = self
        self._isInitialized = true
    }

    private func onReceive(movieId: Int) {
        delegate?.receivedFromPeer(movieId: movieId)
    }

    private func sendToPeers(object: Any, type: DataType) {
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
        delegate?.connectedToCount(peerCount: devices.count)
    }
}
