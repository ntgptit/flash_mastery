import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';
import 'package:flash_mastery/data/models/folder_model.dart';

abstract class FolderRemoteDataSource {
  Future<List<FolderModel>> getFolders({String? parentId});
  Future<FolderModel> getFolderById(String id);
  Future<FolderModel> createFolder(FolderModel folder);
  Future<FolderModel> updateFolder(String id, FolderModel folder);
  Future<void> deleteFolder(String id);
  Future<List<FolderModel>> searchFolders(String query);
}

class FolderRemoteDataSourceImpl implements FolderRemoteDataSource {
  FolderRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<FolderModel>> getFolders({String? parentId}) async {
    final response = await dio.get(
      ApiConstants.folders,
      queryParameters: parentId != null ? {'parentId': parentId} : null,
    );
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(FolderModel.fromJson).toList();
    }
    throw _serverException(response);
  }

  @override
  Future<FolderModel> getFolderById(String id) async {
    final response = await dio.get(ApiConstants.folderById(id));
    if (response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<FolderModel> createFolder(FolderModel folder) async {
    final response = await dio.post(
      ApiConstants.createFolder,
      data: {
        'name': folder.name,
        'description': folder.description,
        'color': folder.color,
        'parentId': folder.parentId,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw _serverException(response);
  }

  @override
  Future<FolderModel> updateFolder(String id, FolderModel folder) async {
    final response = await dio.put(
      ApiConstants.updateFolder(id),
      data: {
        'name': folder.name,
        'description': folder.description,
        'color': folder.color,
        'parentId': folder.parentId,
      },
    );
    if (response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<void> deleteFolder(String id) async {
    final response = await dio.delete(ApiConstants.deleteFolder(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw _notFoundException(response);
    }
    throw _serverException(response);
  }

  @override
  Future<List<FolderModel>> searchFolders(String query) async {
    if (query.isEmpty) return getFolders();
    final all = await getFolders();
    final lower = query.toLowerCase();
    return all
        .where((f) =>
            f.name.toLowerCase().contains(lower) ||
            (f.description ?? '').toLowerCase().contains(lower))
        .toList();
  }
}

NotFoundException _notFoundException(Response response) {
  return NotFoundException(
    message: ApiErrorParser.extractMessage(response.data) ?? 'Resource not found',
    errorCode: ApiErrorParser.extractCode(response.data),
  );
}

ServerException _serverException(Response response) {
  return ServerException(
    message: ApiErrorParser.extractMessage(response.data) ?? response.statusMessage ?? 'Request failed',
    statusCode: response.statusCode,
    errorCode: ApiErrorParser.extractCode(response.data),
  );
}
