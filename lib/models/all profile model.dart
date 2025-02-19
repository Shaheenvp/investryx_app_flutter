import 'package:project_emergio/services/api_list.dart';


class BusinessInvestorExplr {
  final String id;
  final bool? verified;
  final String imageUrl;
  final String image2;
  final String image3;
  final String? image4;
  final String name;
  final String title;
  final String singleLineDescription;
  final String? industry;
  final String? establish_yr;
  final String? description;
  final String? address_1;
  final String? address_2;
  final String? pin;
  final String city;
  final String? state;
  final String? employees;
  final String? entity;
  final String? avg_monthly;
  final String? latest_yearly;
  final String? ebitda;
  final String? rate;
  final String? type_sale;
  final String? url;
  final String? features;
  final String? facility;
  final String? income_source;
  final String? reason;
  final String postedTime;
  final String topSelling;
  String? rangeStarting;
  String? locationIntrested;
  String? rangeEnding;
  String? evaluatingAspects;
  String? companyName;
  String? brandName;
  String? initialInvestment;
  String? iamOffering;
  String? currentNumberOfOutlets;
  String? franchiseTerms;
  String? locationsAvailable;
  String? projectedRoi;
  String? kindOfSupport;
  String? allProducts;
  String? brandStartOperation;
  String? spaceRequiredMin;
  String? spaceRequiredMax;
  String? totalInvestmentFrom;
  String? totalInvestmentTo;
  String? brandFee;
  String? avgNoOfStaff;
  String? avgEBITDA;
  String? avgMonthlySales;
  final String? entityType;
  final List<dynamic>? preference;
  final String? profileSummary;
  final String? askingPrice;

  BusinessInvestorExplr(
      {required this.id,
        required this.imageUrl,
        required this.image2,
        required this.image3,
        required this.singleLineDescription,
        required this.title,
        this.verified,
        this.image4,
        required this.name,
        this.industry,
        this.establish_yr,
        this.description,
        this.address_1,
        this.address_2,
        this.pin,
        required this.city,
        this.state,
        this.employees,
        this.entity,
        this.avg_monthly,
        this.latest_yearly,
        this.ebitda,
        this.rate,
        this.type_sale,
        this.url,
        this.features,
        this.facility,
        this.income_source,
        this.reason,
        this.evaluatingAspects,
        this.companyName,
        this.rangeStarting,
        this.rangeEnding,
        this.locationsAvailable,
        this.brandName,
        this.locationIntrested,
        required this.postedTime,
        required this.topSelling,
        this.entityType,
        this.preference,
        this.profileSummary,
        this.askingPrice
      });

  factory BusinessInvestorExplr.fromJson(Map<String, dynamic> json) {
    return BusinessInvestorExplr(
        id: json['id']?.toString() ?? 'N/A',
        imageUrl: validateUrl(json['image1']) ??
            'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        image2: validateUrl(json['image2']) ??
            'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        image3: validateUrl(json['image3']) ??
            'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
        image4: validateUrl(json['image4']),
        name: json['name']?.toString() ?? 'N/A',
        title: json['title']?.toString() ?? 'N/A',
      verified: json['verified']?? '',
        singleLineDescription:  json['single_desc']?.toString() ?? 'N/A',
        industry: json['industry']?.toString(),
        establish_yr: json['establish_yr']?.toString(),
        description: json['description']?.toString(),
        address_1: json['address_1']?.toString(),
        address_2: json['address_2']?.toString(),
        pin: json['pin']?.toString(),
        city: json['city']?.toString() ?? 'N/A',
        state: json['state']?.toString(),
        employees: json['employees']?.toString(),
        entity: json['entity']?.toString(),
        avg_monthly: json['avg_monthly']?.toString(),
        latest_yearly: json['latest_yearly']?.toString(),
        ebitda: json['ebitda']?.toString(),
        rate: json['range_starting']?.toString(),
        type_sale: json['type_sale']?.toString(),
        url: json['url']?.toString(),
        features: json['features']?.toString(),
        facility: json['facility']?.toString(),
        income_source: json['income_source']?.toString(),
        reason: json['reason']?.toString(),
        postedTime: json['listed_on']?.toString() ?? 'N/A',
        topSelling: json['top_selling']?.toString() ?? 'N/A',
        locationIntrested: json['location_interested']?.toString(),
        rangeStarting: json['range_starting']?.toString(),
        rangeEnding: json['range_ending']?.toString(),
        companyName: json['company']?.toString(),
        evaluatingAspects: json['evaluating_aspects']?.toString(),
        brandName: json['brand_name']?.toString(),
        entityType: json["entity_type"] ?? "",
        preference: json["preference"] ?? [],
        profileSummary: json["profile_summary"] ?? "N/A",
        askingPrice: json["asking_price"] ?? "N/A",
    );
  }

  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

class FranchiseExplr {
  final String? established_year;
  final String imageUrl;
  final String image2;
  final String image3;
  final String image4;
  final String id;
  final bool? verified;
  final String brandName;
  final String title;
  final String singleLineDescription;
  final String city;
  final String postedTime;
  final String? state;
  final String? industry;
  final String? description;
  final String? url;
  final String? initialInvestment;
  final String? projectedRoi;
  final String? iamOffering;
  final String? currentNumberOfOutlets;
  final String? franchiseTerms;
  final String? locationsAvailable;
  final String? kindOfSupport;
  final String? allProducts;
  final String? brandStartOperation;
  final String? spaceRequiredMin;
  final String? spaceRequiredMax;
  final String? totalInvestmentFrom;
  final String? totalInvestmentTo;
  final String? brandFee;
  final String? avgNoOfStaff;
  final String? avgMonthlySales;
  final String? avgEBITDA;
  final String? companyName;
  final String? entityType;
  final String? logo;

  FranchiseExplr(
      {this.established_year,
        required this.imageUrl,
        required this.image2,
        required this.image3,
        required this.image4,
        required this.brandName,
        required this.city,
        required this.postedTime,
        required this.id,
        this.verified,
        this.state,
        this.industry,
        this.description,
        this.url,
        this.initialInvestment,
        this.projectedRoi,
        required this.singleLineDescription,
        required this.title,
        this.iamOffering,
        this.currentNumberOfOutlets,
        this.franchiseTerms,
        this.locationsAvailable,
        this.kindOfSupport,
        this.allProducts,
        this.brandStartOperation,
        this.spaceRequiredMin,
        this.spaceRequiredMax,
        this.totalInvestmentFrom,
        this.totalInvestmentTo,
        this.brandFee,
        this.avgNoOfStaff,
        this.avgMonthlySales,
        this.avgEBITDA,
        this.companyName,
        this.entityType,
        this.logo});

  factory FranchiseExplr.fromJson(Map<String, dynamic> json) {
    return FranchiseExplr(
      title: json['title']?.toString() ?? 'N/A',
      singleLineDescription:  json['single_desc']?.toString() ?? 'N/A',
      verified: json['verified']?? '',
      imageUrl: validateUrl(json['image1']) ??
          'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image2: validateUrl(json['image2']) ??
          'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image3: validateUrl(json['image3']) ??
          'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      image4: validateUrl(json['image4']) ??
          'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      established_year: json['established_year'],
      brandName: json['name'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      industry: json['industry'],
      description: json['description'],
      url: json['url'],
      initialInvestment: json['initial']?.toString(),
      projectedRoi: json['proj_ROI']?.toString(),
      iamOffering: json['offering']?.toString(),
      currentNumberOfOutlets: json['total_outlets']?.toString(),
      franchiseTerms: json['yr_period']?.toString(),
      locationsAvailable: json['locations_available'],
      kindOfSupport: json['supports'],
      allProducts: json['services'],
      brandStartOperation: json['establish_yr']?.toString(),
      spaceRequiredMin: json['min_space']?.toString(),
      spaceRequiredMax: json['max_space']?.toString(),
      totalInvestmentFrom: json['range_starting']?.toString(),
      totalInvestmentTo: json['range_ending']?.toString(),
      brandFee: json['brand_fee']?.toString(),
      avgNoOfStaff: json['staff']?.toString(),
      avgMonthlySales: json['avg_monthly_sales']?.toString(),
      avgEBITDA: json['ebitda']?.toString(),
      companyName: json['company'],
      id: json['id']!.toString(),
      entityType: json["entity_type"] ?? "entity_type",
      logo: validateUrl(json['logo']) ??
          'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',);
  }

  Map<String, dynamic> toJson() {
    return {
      'established_year': established_year,
      'image1': imageUrl,
      'image2': image2,
      'image3': image3,
      'image4': image4,
      'id': id,
      'name': brandName,
      'city': city,
      'listed_on': postedTime,
      'state': state,
      'industry': industry,
      'description': description,
      'url': url,
      'initial': initialInvestment,
      'proj_ROI': projectedRoi,
      'offering': iamOffering,
      'total_outlets': currentNumberOfOutlets,
      'yr_period': franchiseTerms,
      'locations_available': locationsAvailable,
      'supports': kindOfSupport,
      'services': allProducts,
      'establish_yr': brandStartOperation,
      'min_space': spaceRequiredMin,
      'max_space': spaceRequiredMax,
      'range_starting': totalInvestmentFrom,
      'range_ending': totalInvestmentTo,
      'brand_fee': brandFee,
      'staff': avgNoOfStaff,
      'avg_monthly_sales': avgMonthlySales,
      'ebitda': avgEBITDA,
      'company': companyName,
      'entity_type': entityType,
    };
  }




  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

class AdvisorExplr {
  final String imageUrl;
  final String? type;
  final String id;
  final bool? verified;
  final String user;
  final String name;
  final String title;
  final String singleLineDescription;
  final String? designation;
  final String location;
  final String postedTime;
  final String? state;
  final String? expertise;
  final String? experience;
  final String? url;
  final String? contactNumber;
  final String? interest;
  final String? description;
  final List<String>? brandLogo;
  final List<String>? businessPhotos;
  final String? businessProof;
  final List<String>? businessDocuments;

  AdvisorExplr( {
    required this.imageUrl,
    required this.id,
    this.verified,
    required this.user,
    required this.name,
    required this.location,
    required this.postedTime,
    this.type,
    this.state,
    this.designation,
    required this.singleLineDescription,
    required this.title,
    this.expertise,
    this.experience,
    this.url,
    this.contactNumber,
    this.interest,
    this.description,
    this.brandLogo,
    this.businessPhotos,
    this.businessProof,
    this.businessDocuments,
  });

  factory AdvisorExplr.fromJson(Map<String, dynamic> json) {
    return AdvisorExplr(
      title: json['title']?.toString() ?? 'N/A',
      singleLineDescription:  json['single_desc']?.toString() ?? 'N/A',
      imageUrl:
      validateUrl(json['logo']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      name: json['name'] ?? 'N/A',
      designation: json['designation'] ?? 'Expert',
      location: json['city'] ?? 'N/A',
      postedTime: json['listed_on'] ?? 'N/A',
      state: json['state'],
      expertise: json['industry'],
      experience: json['experience'],
      url: json['email'],
      type: json["type"].toString(),
      contactNumber: json['number'],
      interest: json['interest'],
      description: json['description'],
      id: json['id']?.toString() ?? '',
      verified: json['verified']?? '',
      user: json['user']?.toString() ?? '',
      brandLogo: json['brandLogo'] != null
          ? List<String>.from(json['brandLogo'])
          : null,
      businessPhotos: json['businessPhotos'] != null
          ? List<String>.from(json['businessPhotos'])
          : null,
      businessProof: json['businessProof'],
      businessDocuments: json['businessDocuments'] != null
          ? List<String>.from(json['businessDocuments'])
          : null,
    );
  }

  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
    }
}
