//
//  RxKingfisher.swift
//  RxKingfisher
//
//  Created by Shai Mishali on 5/5/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base == KingfisherWrapper<ImageView> {
    public func setImage(with resource: Resource?,
                         placeholder: Placeholder? = nil,
                         options: KingfisherOptionsInfo? = nil) -> Single<Image> {
        return Single<Image>.create { [base] single in
            let task = base.setImage(
                with: resource,
                placeholder: placeholder,
                options: options,
                progressBlock: nil,
                completionHandler: { (result) in
                    switch result {
                    case let .failure(error):
                        single(.error(RxKingfisherError.kingfisherError(error)))
                    case let .success(value):
                        let image = value.image
                        single(.success(image))
                    }
            })
            
            return Disposables.create { task?.cancel() }
        }
    }

    public func image(placeholder: Placeholder? = nil,
                      options: KingfisherOptionsInfo? = nil) -> Binder<URL?> {
        // `base.base` is the `Kingfisher` class' associated `ImageView`.
        return Binder(base.base) { imageView, image in
            imageView.kf.setImage(with: image,
                                  placeholder: placeholder,
                                  options: options)
        }
    }
}

extension KingfisherWrapper: ReactiveCompatible { }
