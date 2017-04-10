import 'dart:async';
import 'dart:convert';

import 'package:angular2/core.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

@Injectable()
class TimeSheetInMemoryDataService extends MockClient {
  static final _initialRequests = new List<Object>();
  static final List<Object> _requestsDb = _initialRequests;

  static final _initialContracts = new List<Object>();
  static final List<Object> _contractsDb = _initialContracts;

  static final _initialCallOffs = new List<Object>();
  static final List<Object> _callOffsDb = _initialCallOffs;

  TimeSheetInMemoryDataService() : super(_handler) {
    _initialRequests.add({
      'id': '1',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '2',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '3',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'odobrena',
      'statusSysName': 'approved'
    });
    _initialRequests.add({
      'id': '4',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'deny',
      'statusSysName': 'deny'
    });
    _initialRequests.add({
      'id': '5',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'new',
      'statusSysName': 'new'
    });
    _initialRequests.add({
      'id': '6',
      'startDate': '10.10.2015',
      'updateDate': '12.12.2015',
      'contractNumber': '403/25-YSPG (dop. 2)',
      'contractorName': 'Podryadchik',
      'amount': 300000000,
      'currencyName': 'rub',
      'statusName': 'errors',
      'statusSysName': 'error'
    });

    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e01c610",
      "name": "Ljujdjh (Default)",
      "number": "1-L/ZCGU",
      "startDate": "20.03.2017",
      "finishDate": "22.03.2017",
      "contractorName": "Gjlhzlxbr",
      "currency": "he,",
      "amount": "350 000 000",
      "vatIncluded": true,
      "constructionObjectName": "J,]trn 10",
      "constructionObjectTitleName": "Nbnekmysq cgbcjr j,]trnf 10",
      "constructionObjectTitleCode": "553",
      "description":
      "Ehfdytybt juhjvyj/ Dsgfhbdfybt? d cjukfcbb c nhflbwbjyysvb ghtlcnfdktybzvb? athvtynfnbdyj nbnhetn yerktjabk/ Rhfcbntkm rhbcnfkkbxty/ Ghj,bhrf? rfr b dtplt d ghtltkf[ yf,k.lftvjq dctktyyjq? j,kexftn ytcbvvtnhbxysq lbvth/ Utnthjutyyfz cbcntvf ghtlcnfdkztn cj,jq bvblfpjk/ Hfymit extyst gjkfufkb? xnj 'ktrnhjyyjt j,kfrj j,kexftn ufpjj,hfpysq rfnbjybn ghb k.,jq njxtxyjq uheggt cbvvtnhbb/",
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e020cfb",
      "name": "Tot jlby ljujdjh",
      "number": "1234",
      "startDate": "28.03.2017",
      "finishDate": "28.03.2017",
      "contractorName": "Gjlhzlxbr",
      "currency": "usd",
      "amount": "400 000",
      "vatIncluded": true,
      "constructionObjectName": "J,]trn 8",
      "constructionObjectTitleName": "J,]trn 8",
      "constructionObjectTitleCode": "555",
      "description":
      "Jlyfrj? ghb edtkbxtybb ds,jhrb kfnthbn ghbnzubdftn ytjlyjhjlysq ehjdtym uheynjds[ djl/ Gjnecrekf? dcktlcndbt ghjcnhfycndtyyjq ytjlyjhjlyjcnb gjxdtyyjuj gjrhjdf? dthjznyf/ Rfr cktletn bp pfrjyf cj[hfytybz vfccs b 'ythubb? bccktljdfybt cyb;ftn ujyxfhysq lhtyf;? jlyjpyfxyj cdbltntkmcndez j ytecnjqxbdjcnb ghjwtccf d wtkjv/ Vfrhjgjhf? rfr njuj nht,e.n pfrjys nthvjlbyfvbrb? bycnhevtynfkmyj j,yfhe;bvf/",
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e0213bf",
      "name": "Ljujdjh wtyysq",
      "number": "765",
      "startDate": "22.03.2017",
      "finishDate": "29.03.2017",
      "contractorName": "Gjlhzlxbr",
      "currency": "he,",
      "amount": "580 000",
      "vatIncluded": false,
      "constructionObjectName": "J,]trn ,jkmijq",
      "constructionObjectTitleName": "Yfbvtyjdfybt",
      "constructionObjectTitleCode": "234",
      "description":
      "Jcj,e. wtyyjcnm? yf yfi dpukzl? ghtlcnfdkztn rjynhfcn cjwbfkmyj jnxe;lftn abkjutytp/ Cjpyfybt? d gthdjv ghb,kb;tybb? gjybvftn hjktdjq rjvgktrc/ Gjdtltyxtcrfz nthfgbz? ytcvjnhz yf dytiybt djpltqcndbz? dthjznyf/ Htaktrcbz byntuhbhetn vtnjljkjubxtcrbq rjynhfcn? b 'nj ytelbdbntkmyj? tckb htxm j gthcjybabwbhjdfyyjv [fhfrntht gthdbxyjq cjwbfkbpfwbb/",
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e0221fd",
      "name": "Ljujdjh ljhjujq",
      "number": "453",
      "startDate": "13.03.2017",
      "finishDate": "31.03.2017",
      "contractorName": "Gjlhzlxbr",
      "currency": "he,",
      "amount": "250 000 000",
      "vatIncluded": false,
      "constructionObjectName": "J,]trn 214",
      "constructionObjectTitleName": null,
      "constructionObjectTitleCode": null,
      "description": null,
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e022c09",
      "name": "Ljujdjh gznm",
      "number": "544",
      "startDate": "31.03.2017",
      "finishDate": "28.03.2017",
      "contractorName": "Gjlhzlxbr 23",
      "currency": "he,",
      "amount": "540 000",
      "vatIncluded": true,
      "constructionObjectName": "J,]trn ",
      "constructionObjectTitleName": null,
      "constructionObjectTitleCode": "234",
      "description": "Jgbcfybt",
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e02334d",
      "name": "Tot jlby ljujdjh",
      "number": "23",
      "startDate": "16.03.2017",
      "finishDate": "16.03.2017",
      "contractorName": "Gjlhzlxbr 44",
      "currency": "he,",
      "amount": "100 000",
      "vatIncluded": true,
      "constructionObjectName": "224dfsdf",
      "constructionObjectTitleName": "sdfsdf",
      "constructionObjectTitleCode": "12323",
      "description":
      "Djple[jcjlth;fybt revekznbdyj/ Nhfyitz dsvsdftn d uhfyekjvtnhbxtcrbq fyfkbp/ Gjdth[yjcnm hfpltkf afp ljcnegyf/ Ghjwtcc? d gthdjv ghb,kb;tybb? ljcnjdthyj edkf;yztn ,.rc/",
      "templateSysName": null
    });
    _initialContracts.add({
      "id": "26270cfa2422b2c4ebf158285e023f25",
      "name": "Ljujdjh ctvm",
      "number": "553",
      "startDate": "24.03.2017",
      "finishDate": "19.05.2017",
      "contractorName": "Gjlhzlxbr 23",
      "currency": "usd",
      "amount": "659 000 000",
      "vatIncluded": true,
      "constructionObjectName": "J,]trn 0",
      "constructionObjectTitleName": "Yfbvtyjdfybt",
      "constructionObjectTitleCode": "34",
      "description":
      "D gthdjv ghb,kb;tybb ;ehfdxbr djccnfyfdkbdftn k`cc? dct lfkmytqitt lfktrj ds[jlbn pf hfvrb ntreotuj bccktljdfybz b yt ,eltn pltcm hfccvfnhbdfnmcz/ Cdjqcndj? dcktlcndbt ghjcnhfycndtyyjq ytjlyjhjlyjcnb gjxdtyyjuj gjrhjdf? vuyjdtyyj rjywtynhbhetn ytghjvsdyjq dkfujvth/ Yfghz;tybt [bvbxtcrb jnhf;ftn vjyjkbn/ Vfrhjgjhf djccnfyfdkbdftn fuhtufn/ :ehfdxbr edkf;yztn jhnpfyl/ Ahfrnfk djpybrftn vt;fuhtufnysq uevby/",
      "templateSysName": null
    });

    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e05f973",
      "contractId": "26270cfa2422b2c4ebf158285e050f11",
      "number": "123/ZVFKCGU",
      "assignee": null,
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-20T15:12:25.6898197+03:00",
      "startDate": null,
      "finishDate": null,
      "name": "Vtldtl",
      "position": null,
      "location": null,
      "templateSysName": "default",
      "templateData": {},
      "rates": [
        {
          "id": 1,
          "name": "d",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": null,
          "unitName": null
        },
        {
          "id": 2,
          "name": "asdfasdf",
          "isRate": true,
          "parentId": null,
          "amount": 1000.0,
          "currency": "RUR",
          "unitName": "fhfgh."
        }
      ]
    });
    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e060198",
      "contractId": "26270cfa2422b2c4ebf158285e050f11",
      "number": "123/sd22hgf",
      "assignee": null,
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-24T16:05:20.0844016+03:00",
      "startDate": null,
      "finishDate": null,
      "name": "7",
      "position": null,
      "location": null,
      "templateSysName": "default",
      "templateData": {},
      "rates": [
        {
          "id": 1,
          "name": "1321212312313",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": null,
          "unitName": null
        },
        {
          "id": 3,
          "name": "1",
          "isRate": true,
          "parentId": 1,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 5,
          "name": "3",
          "isRate": true,
          "parentId": 3,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 4,
          "name": "2",
          "isRate": true,
          "parentId": 3,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 2,
          "name": "23",
          "isRate": true,
          "parentId": null,
          "amount": 1000.0,
          "currency": "RUR",
          "unitName": "dghdfgh."
        },
        {
          "id": 6,
          "name": "121212",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        }
      ]
    });
    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e062c64",
      "contractId": "26270cfa2422b2c4ebf158285e050f11",
      "number": "dfghdfgh",
      "assignee": null,
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-20T13:48:33.3246930+03:00",
      "startDate": null,
      "finishDate": null,
      "name": "dfhgdfgh",
      "position": null,
      "location": null,
      "templateSysName": "default",
      "templateData": {},
      "rates": []
    });
    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e06440e",
      "contractId": "26270cfa2422b2c4ebf158285e01c610",
      "number": "1-V/ZCGU",
      "assignee": "Gegrby Dfcbkbq",
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-23T14:19:10.5603560+03:00",
      "startDate": "01.03.2017",
      "finishDate": "01.03.2017",
      "name": "Gjvsnm gjks",
      "position": "Ldjhybr",
      "location": "Thtdfy Gkfpf",
      "templateSysName": "default",
      "templateData": {},
      "rates": [
        {
          "id": 1,
          "name": "Uheggf 1",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": null,
          "unitName": null
        },
        {
          "id": 3,
          "name": "Cnfdrf gjl uheggjq 1",
          "isRate": true,
          "parentId": 1,
          "amount": 1.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 2,
          "name": "Cnfdrf 1 tp uheggs",
          "isRate": true,
          "parentId": null,
          "amount": 1000.0,
          "currency": "RUR",
          "unitName": "ly."
        },
        {
          "id": 4,
          "name": "Uheggf 2",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 5,
          "name": "Cnfdrf 1 gjl uheggjq 2",
          "isRate": true,
          "parentId": 4,
          "amount": 2.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 6,
          "name": "Cnfdrf 2 gjl uheggjq 2",
          "isRate": true,
          "parentId": 5,
          "amount": 3.0,
          "currency": "USD",
          "unitName": "ltym"
        },
        {
          "id": 7,
          "name": "Cnfdrf 2 tp uheggs",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": "USD",
          "unitName": "ltym"
        }
      ]
    });
    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e065879",
      "contractId": "26270cfa2422b2c4ebf158285e050f11",
      "number": "1",
      "assignee": "sd",
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-21T15:57:44.9683623+03:00",
      "startDate": null,
      "finishDate": null,
      "name": "DF",
      "position": "ASFD",
      "location": "ASFD",
      "templateSysName": "default",
      "templateData": {},
      "rates": []
    });
    _initialCallOffs.add({
      "id": "26270cfa2422b2c4ebf158285e075cd5",
      "contractId": "26270cfa2422b2c4ebf158285e01c610",
      "number": "1-U/ZCGU",
      "assignee": "Bdfyjd Bdfy1",
      "createdAt": "0001-01-01T00:00:00.0000000+03:00",
      "updatedAt": "2017-03-29T16:56:53.3321037+03:00",
      "startDate": "30.03.2017",
      "finishDate": "31.03.2017",
      "name": "Rjynhjkm vjqrb gjkjd",
      "position": "Utylbh",
      "location": "Fh,fn",
      "templateSysName": "default",
      "templateData": {},
      "rates": [
        {
          "id": 1,
          "name": "Eckeuf",
          "isRate": false,
          "parentId": null,
          "amount": 0.0,
          "currency": null,
          "unitName": null
        },
        {
          "id": 2,
          "name": "Ds[jlyst",
          "isRate": true,
          "parentId": null,
          "amount": 1000.0,
          "currency": "RUR",
          "unitName": "ly."
        }
      ]
    });
  }

  static Future<Response> _handler(Request request) async {
    var data;
    switch (request.method) {
      case 'GET':
        final id =
        int.parse(request.url.pathSegments.last, onError: (_) => null);
        if (id != null) {
          data = _requestsDb
            .firstWhere((item) => item.id == id); // throws if no match
        } else {
          switch (request.url.pathSegments.last) {
            case 'requests':
              data = _requestsDb;
              break;
            case 'contracts':
              data = _contractsDb;
              break;
            case 'call-off-orders':
              data = _callOffsDb;
              break;
          }
        }
        break;
      case 'POST':
        break;
      case 'PUT':
        break;
      case 'DELETE':
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }

    String responseData = JSON.encode(data);

    return new Response(responseData, 200,
      headers: {'content-type': 'application/json'});
  }
}