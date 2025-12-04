import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/data/models/folder_model.dart';

abstract class FolderRemoteDataSource {
  Future<List<FolderModel>> getFolders();
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
  Future<List<FolderModel>> getFolders() async {
    final response = await dio.get(ApiConstants.folders);
    if (response.statusCode == 200) {
      final data = (response.data as List).cast<Map<String, dynamic>>();
      return data.map(FolderModel.fromJson).toList();
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to load folders');
  }

  @override
  Future<FolderModel> getFolderById(String id) async {
    final response = await dio.get(ApiConstants.folderById(id));
    if (response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Folder not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to load folder');
  }

  @override
  Future<FolderModel> createFolder(FolderModel folder) async {
    final response = await dio.post(
      ApiConstants.createFolder,
      data: {
        'name': folder.name,
        'description': folder.description,
        'color': folder.color,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to create folder');
  }

  @override
  Future<FolderModel> updateFolder(String id, FolderModel folder) async {
    final response = await dio.put(
      ApiConstants.updateFolder(id),
      data: {
        'name': folder.name,
        'description': folder.description,
        'color': folder.color,
      },
    );
    if (response.statusCode == 200) {
      return FolderModel.fromJson(response.data as Map<String, dynamic>);
    }
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Folder not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to update folder');
  }

  @override
  Future<void> deleteFolder(String id) async {
    final response = await dio.delete(ApiConstants.deleteFolder(id));
    if (response.statusCode == 204) return;
    if (response.statusCode == 404) {
      throw const NotFoundException(message: 'Folder not found');
    }
    throw ServerException(message: response.statusMessage ?? 'Failed to delete folder');
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
