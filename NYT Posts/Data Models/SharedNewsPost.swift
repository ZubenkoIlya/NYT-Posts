//
//  SharedNewsPost.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 12.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SharedNewsPost {
    
    var mainImage: UIImage = UIImage(named: "placeholder")!
    
    var url: String = "" //url
    var adx_keywords: String = "" //adx_keywords
    var subsection: String = "" //subsection
    var share_count: Int = 0 //share_count
    var count_type: String = "" //count_type
    var column: String = "" //column
    var eta_id: Int = 0 //eta_id
    var section: String = "" //section
    var id: Int64 = 0 //id
    var asset_id: Int64 = 0 //asset_id
    var nytdsection: String = "" //nytdsection
    var byline: String = "" //byline
    var type: String = "" //type
    var title: String = "" //title
    var abstract: String = "" //abstract
    var published_date: String = "" //published_date "yyyy-mm-dd"
    var source: String = "" //source
    var updated: String = "" //updated "yyy-mm-dd hh:mm:ss"
    var des_facet: [String] = [] //des_facet
    var org_facet: [String] = [] //org_facet
    var per_facet: [String] = [] //per_facet
    var geo_facet: [String] = [] //geo_facet
    
    var media: [JSON] = [] //media
    var typeMedia: String = "" //media -> type
    var subtypeMedia: String = "" //media -> subtype
    var captionMedia: String = "" //media -> caption
    var copyrightMedia: String = "" //media -> copyright
    var approved_for_syndicationMedia: Int? //media -> approved_for_syndication
    
    var media_metadata: [[String:Any]] = [[:]] //media -> media-metadata
    var url_media_metadata: String = "" //media -> media-metadata -> url
    var format_media_metadata: String = "" //media -> media-metadata -> format
    var height_media_metadata: String = "" //media -> media-metadata -> height
    var width_media_metadata: String = "" //media -> media-metadata -> wight
    
    var uri: String = "" //uri
    
    init() { }
    
    init(url: String, adx_keywords: String, subsection: String, share_count: Int, count_type: String, column: String ,eta_id: Int, section: String, id: Int64, asset_id: Int64, nytdsection: String, byline: String, type: String, title: String, abstract: String, published_date: String, source: String, updated: String, des_facet: [String], org_facet: [String], per_facet: [String], geo_facet: [String], media: [JSON], typeMedia: String, subtypeMedia: String, captionMedia: String, copyrightMedia: String, approved_for_syndicationMedia: Int, media_metadata: [[String:Any]], url_media_metadata: String, format_media_metadata: String, height_media_metadata: String, width_media_metadata: String, uri: String) {
        
        self.url = url
        self.adx_keywords = adx_keywords
        self.subsection = subsection
        self.share_count = share_count
        self.count_type = count_type
        self.column = column
        self.eta_id = eta_id
        self.section = section
        self.id = id
        self.asset_id = asset_id
        self.nytdsection = nytdsection
        self.byline = byline
        self.type = type
        self.title = title
        self.abstract = abstract
        self.published_date = published_date
        self.source = source
        self.updated = updated
        self.des_facet = des_facet
        self.org_facet = org_facet
        self.per_facet = per_facet
        self.geo_facet = geo_facet
        self.media = media
        self.typeMedia = typeMedia
        self.subtypeMedia = subtypeMedia
        self.captionMedia = captionMedia
        self.copyrightMedia = copyrightMedia
        self.approved_for_syndicationMedia = approved_for_syndicationMedia
        self.media_metadata = media_metadata
        self.url_media_metadata = url_media_metadata
        self.format_media_metadata = format_media_metadata
        self.height_media_metadata = height_media_metadata
        self.width_media_metadata = width_media_metadata
        self.uri = uri
    }
    
}



