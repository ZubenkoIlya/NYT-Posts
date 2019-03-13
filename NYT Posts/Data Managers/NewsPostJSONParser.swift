//
//  NewsPostJSONParser.swift
//  NYT Posts
//
//  Created by Илья Зубенко on 11.03.19.
//  Copyright © 2019 ZubenkoApps. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

var emailedPostsArray: [EmailedNewsPost] = []
var sharedPostsArray: [SharedNewsPost] = []
var viewedPostsArray: [ViewedNewsPost] = []

class NewsPostJSONParser: NSObject {
    
    static let shared = NewsPostJSONParser()
    
    func getMostEmailedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                emailedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func getMostViewedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                viewedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func getMostSharedPosts(closure: @escaping () -> ()){
        
        let url = "https://api.nytimes.com/svc/mostpopular/v2/shared/30/facebook.json?api-key=\(NYTMostPopularAPIKey)"
        
        Alamofire.request(url).responseJSON { (response) in
            if let data = response.data {
                sharedPostsArray = self.createFrom(data: data)
                closure()
            }
        }
        
    }
    
    func createFrom(data: Data) -> [EmailedNewsPost] {
        var emailedNewsPostsArray: [EmailedNewsPost] = []
        
        do {
            let json = try JSON(data: data)
            let jsonPosts = json["results"]
            let jArray = jsonPosts.arrayValue
            
            for post in jArray {
                let url = post["url"].rawString() ?? ""
                let adx_keywords = post["adx_keywords"].rawString() ?? ""
                let subsection = post["subsection"].rawString() ?? ""
                let email_count = post["email_count"].int ?? 0
                let count_type = post["count_type"].rawString() ?? ""
                let column = post["column"].int ?? 0
                let eta_id = post["eta_id"].int ?? 0
                let section = post["section"].rawString() ?? ""
                let id = post["id"].int64 ?? 0
                let asset_id = post["asset_id"].int64 ?? 0
                let nytdsection = post["nytdsection"].rawString() ?? ""
                let byline = post["byline"].rawString() ?? ""
                let type = post["type"].rawString() ?? ""
                let title = post["title"].rawString() ?? ""
                let abstract = post["abstract"].rawString() ?? ""
                let published_date = post["published_date"].rawString() ?? ""
                let source = post["source"].rawString() ?? ""
                let updated = post["updated"].rawString() ?? ""
                
                let des_facetArray = post["des_facet"].arrayValue
                var des_facet: [String] = []
                for element in des_facetArray {
                    des_facet.append(element.string ?? "")
                }
                
                let org_facetArray = post["org_facet"].arrayValue
                var org_facet: [String] = []
                for element in org_facetArray {
                    org_facet.append(element.string ?? "")
                }
                
                let per_facetArray = post["per_facet"].arrayValue
                var per_facet: [String] = []
                for element in per_facetArray {
                    per_facet.append(element.string ?? "")
                }
                
                let geo_facetArray = post["geo_facet"].arrayValue
                var geo_facet: [String] = []
                for element in geo_facetArray {
                    geo_facet.append(element.string ?? "")
                }
                
                let media = post["media"].array
                let typeMedia = media![0]["type"].string ?? ""
                let subtypeMedia = media![0]["subtype"].rawString() ?? ""
                let captionMedia = media![0]["caption"].rawString() ?? ""
                let copyrightMedia = media![0]["copyright"].rawString() ?? ""
                let approved_for_syndicationMedia = media![0]["approved_for_syndication"].int ?? 0
                
                let media_metadataArray = media![0]["media-metadata"].array
                var media_metadata: [[String: JSON]] = []
                for element in media_metadataArray! {
                    media_metadata.append(element.dictionary!)
                }
                
                var url_media_metadata = ""
                var format_media_metadata = ""
                var height_media_metadata = ""
                var width_media_metadata = ""
                for element in media_metadata {
                    if element["format"]?.stringValue == "mediumThreeByTwo210" {
                        url_media_metadata = element["url"]!.stringValue
                        format_media_metadata = element["format"]!.stringValue
                        height_media_metadata = element["height"]!.stringValue
                        width_media_metadata = element["width"]!.stringValue
                    }
                }
                
                let uri = post["uri"].rawString() ?? ""
                
                let emailedNewsPost = EmailedNewsPost(url: url, adx_keywords: adx_keywords, subsection: subsection, email_count: email_count, count_type: count_type, column: column, eta_id: eta_id, section: section, id: id, asset_id: asset_id, nytdsection: nytdsection, byline: byline, type: type, title: title, abstract: abstract, published_date: published_date, source: source, updated: updated, des_facet: des_facet, org_facet: org_facet, per_facet: per_facet, geo_facet: geo_facet, media: media!, typeMedia: typeMedia, subtypeMedia: subtypeMedia, captionMedia: captionMedia, copyrightMedia: copyrightMedia, approved_for_syndicationMedia: approved_for_syndicationMedia, media_metadata: media_metadata, url_media_metadata: url_media_metadata, format_media_metadata: format_media_metadata, height_media_metadata: height_media_metadata, width_media_metadata: width_media_metadata, uri: uri)
                
                print("emailedNewsPost: ", emailedNewsPost)
                emailedNewsPostsArray.append(emailedNewsPost)
            }
            
            return emailedNewsPostsArray
        } catch {
            return emailedNewsPostsArray
        }
    }
    
    func createFrom(data: Data) -> [ViewedNewsPost] {
        var viewedNewsPostsArray: [ViewedNewsPost] = []
        
        do {
            let json = try JSON(data: data)
            let jsonPosts = json["results"]
            let jArray = jsonPosts.arrayValue
            
            for post in jArray {
                let url = post["url"].rawString() ?? ""
                let adx_keywords = post["adx_keywords"].rawString() ?? ""
                let column = post["column"].rawString() ?? ""
                let section = post["section"].rawString() ?? ""
                let byline = post["byline"].rawString() ?? ""
                let type = post["type"].rawString() ?? ""
                let title = post["title"].rawString() ?? ""
                let abstract = post["abstract"].rawString() ?? ""
                let published_date = post["published_date"].rawString() ?? ""
                let source = post["source"].rawString() ?? ""
                let id = post["id"].int64 ?? 0
                let asset_id = post["asset_id"].int64 ?? 0
                let views = post["views"].int ?? 0
                
                let des_facetArray = post["des_facet"].arrayValue
                var des_facet: [String] = []
                for element in des_facetArray {
                    des_facet.append(element.string ?? "")
                }
                
                let org_facetArray = post["org_facet"].arrayValue
                var org_facet: [String] = []
                for element in org_facetArray {
                    org_facet.append(element.string ?? "")
                }
                
                let per_facetArray = post["per_facet"].arrayValue
                var per_facet: [String] = []
                for element in per_facetArray {
                    per_facet.append(element.string ?? "")
                }
                
                let geo_facetArray = post["geo_facet"].arrayValue
                var geo_facet: [String] = []
                for element in geo_facetArray {
                    geo_facet.append(element.string ?? "")
                }
                
                let media = post["media"].array
                let typeMedia = media![0]["type"].string ?? ""
                let subtypeMedia = media![0]["subtype"].rawString() ?? ""
                let captionMedia = media![0]["caption"].rawString() ?? ""
                let copyrightMedia = media![0]["copyright"].rawString() ?? ""
                let approved_for_syndicationMedia = media![0]["approved_for_syndication"].int ?? 0
                
                let media_metadataArray = media![0]["media-metadata"].array
                var media_metadata: [[String: JSON]] = []
                for element in media_metadataArray! {
                    media_metadata.append(element.dictionary!)
                }
                
                var url_media_metadata = ""
                var format_media_metadata = ""
                var height_media_metadata = ""
                var width_media_metadata = ""
                for element in media_metadata {
                    if element["format"]?.stringValue == "mediumThreeByTwo210" {
                        url_media_metadata = element["url"]!.stringValue
                        format_media_metadata = element["format"]!.stringValue
                        height_media_metadata = element["height"]!.stringValue
                        width_media_metadata = element["width"]!.stringValue
                    }
                }
                
                let uri = post["uri"].rawString() ?? ""
                
                let viewedNewsPost = ViewedNewsPost(url: url, adx_keywords: adx_keywords, column: column, section: section, id: id, asset_id: asset_id, byline: byline, type: type, title: title, abstract: abstract, published_date: published_date, source: source, views: views, des_facet: des_facet, org_facet: org_facet, per_facet: per_facet, geo_facet: geo_facet, media: media!, typeMedia: typeMedia, subtypeMedia: subtypeMedia, captionMedia: captionMedia, copyrightMedia: copyrightMedia, approved_for_syndicationMedia: approved_for_syndicationMedia, media_metadata: media_metadata, url_media_metadata: url_media_metadata, format_media_metadata: format_media_metadata, height_media_metadata: height_media_metadata, width_media_metadata: width_media_metadata, uri: uri)
                
                print("viewedNewsPost: ", viewedNewsPost)
                viewedNewsPostsArray.append(viewedNewsPost)
            }
            
            return viewedNewsPostsArray
        } catch {
            return viewedNewsPostsArray
        }
    }
    
    func createFrom(data: Data) -> [SharedNewsPost] {
        var sharedNewsPostsArray: [SharedNewsPost] = []
        
        do {
            let json = try JSON(data: data)
            let jsonPosts = json["results"]
            let jArray = jsonPosts.arrayValue
            
            for post in jArray {
                let url = post["url"].rawString() ?? ""
                let adx_keywords = post["adx_keywords"].rawString() ?? ""
                let subsection = post["subsection"].rawString() ?? ""
                let share_count = post["share_count"].int ?? 0
                let count_type = post["count_type"].rawString() ?? ""
                let column = post["column"].rawString() ?? ""
                let eta_id = post["eta_id"].int ?? 0
                let section = post["section"].rawString() ?? ""
                let id = post["id"].int64 ?? 0
                let asset_id = post["asset_id"].int64 ?? 0
                let nytdsection = post["nytdsection"].rawString() ?? ""
                let byline = post["byline"].rawString() ?? ""
                let type = post["type"].rawString() ?? ""
                let title = post["title"].rawString() ?? ""
                let abstract = post["abstract"].rawString() ?? ""
                let published_date = post["published_date"].rawString() ?? ""
                let source = post["source"].rawString() ?? ""
                let updated = post["updated"].rawString() ?? ""
                
                let des_facetArray = post["des_facet"].arrayValue
                var des_facet: [String] = []
                for element in des_facetArray {
                    des_facet.append(element.string ?? "")
                }
                
                let org_facetArray = post["org_facet"].arrayValue
                var org_facet: [String] = []
                for element in org_facetArray {
                    org_facet.append(element.string ?? "")
                }
                
                let per_facetArray = post["per_facet"].arrayValue
                var per_facet: [String] = []
                for element in per_facetArray {
                    per_facet.append(element.string ?? "")
                }
                
                let geo_facetArray = post["geo_facet"].arrayValue
                var geo_facet: [String] = []
                for element in geo_facetArray {
                    geo_facet.append(element.string ?? "")
                }
                
                let media = post["media"].array
                let typeMedia = media![0]["type"].string ?? ""
                let subtypeMedia = media![0]["subtype"].rawString() ?? ""
                let captionMedia = media![0]["caption"].rawString() ?? ""
                let copyrightMedia = media![0]["copyright"].rawString() ?? ""
                let approved_for_syndicationMedia = media![0]["approved_for_syndication"].int ?? 0
                
                let media_metadataArray = media![0]["media-metadata"].array
                var media_metadata: [[String: JSON]] = []
                for element in media_metadataArray! {
                    media_metadata.append(element.dictionary!)
                }
                
                var url_media_metadata = ""
                var format_media_metadata = ""
                var height_media_metadata = ""
                var width_media_metadata = ""
                for element in media_metadata {
                    if element["format"]?.stringValue == "mediumThreeByTwo210" {
                        url_media_metadata = element["url"]!.stringValue
                        format_media_metadata = element["format"]!.stringValue
                        height_media_metadata = element["height"]!.stringValue
                        width_media_metadata = element["width"]!.stringValue
                    }
                }
                
                let uri = post["uri"].rawString() ?? ""
                
                let sharedNewsPost = SharedNewsPost(url: url, adx_keywords: adx_keywords, subsection: subsection, share_count: share_count, count_type: count_type, column: column, eta_id: eta_id, section: section, id: id, asset_id: asset_id, nytdsection: nytdsection, byline: byline, type: type, title: title, abstract: abstract, published_date: published_date, source: source, updated: updated, des_facet: des_facet, org_facet: org_facet, per_facet: per_facet, geo_facet: geo_facet, media: media!, typeMedia: typeMedia, subtypeMedia: subtypeMedia, captionMedia: captionMedia, copyrightMedia: copyrightMedia, approved_for_syndicationMedia: approved_for_syndicationMedia, media_metadata: media_metadata, url_media_metadata: url_media_metadata, format_media_metadata: format_media_metadata, height_media_metadata: height_media_metadata, width_media_metadata: width_media_metadata, uri: uri)
                
                print("sharedNewsPost: ", sharedNewsPost)
                sharedNewsPostsArray.append(sharedNewsPost)
            }
            
            return sharedNewsPostsArray
        } catch {
            return sharedNewsPostsArray
        }
    }
}
