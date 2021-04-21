import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

part 'photobooth_event.dart';
part 'photobooth_state.dart';

class PhotoboothBloc extends Bloc<PhotoboothEvent, PhotoboothState> {
  PhotoboothBloc() : super(const PhotoboothState());

  @override
  Stream<PhotoboothState> mapEventToState(PhotoboothEvent event) async* {
    if (event is PhotoCaptured) {
      yield state.copyWith(image: event.image);
    } else if (event is PhotoCharacterToggled) {
      yield _mapCharacterToggledToState(event, state);
    } else if (event is PhotoCharacterDragged) {
      yield _mapCharacterDraggedToState(event, state);
    } else if (event is PhotoStickerTapped) {
      yield _mapStickerTappedToState(event, state);
    } else if (event is PhotoStickerDragged) {
      yield _mapStickerDraggedToState(event, state);
    } else if (event is PhotoClearStickersTapped) {
      yield state.copyWith(stickers: const <PhotoAsset>[]);
    } else if (event is PhotoClearAllTapped) {
      yield state.copyWith(
        characters: const <PhotoAsset>[],
        stickers: const <PhotoAsset>[],
        selectedAssetId: emptyAssetId,
      );
    } else if (event is PhotoDeleteStickerTapped) {
      yield _mapDeleteStickerTappedToState(event, state);
    } else if (event is PhotoTapped) {
      yield state.copyWith(selectedAssetId: emptyAssetId);
    }
  }

  PhotoboothState _mapCharacterToggledToState(
    PhotoCharacterToggled event,
    PhotoboothState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((c) => c.asset.name == asset.name);
    final characterExists = index != -1;

    if (characterExists) {
      characters.removeAt(index);
      return state.copyWith(characters: characters);
    }

    final newCharacter = PhotoAsset(id: characters.length, asset: asset);
    characters.add(newCharacter);
    return state.copyWith(
      characters: characters,
      selectedAssetId: newCharacter.id,
    );
  }

  PhotoboothState _mapCharacterDraggedToState(
    PhotoCharacterDragged event,
    PhotoboothState state,
  ) {
    final asset = event.character;
    final characters = List.of(state.characters);
    final index = characters.indexWhere((element) => element.id == asset.id);
    final character = characters.removeAt(index);
    characters.add(
      character.copyWith(
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    return state.copyWith(characters: characters, selectedAssetId: asset.id);
  }

  PhotoboothState _mapStickerTappedToState(
    PhotoStickerTapped event,
    PhotoboothState state,
  ) {
    final asset = event.sticker;
    final newSticker = PhotoAsset(id: state.stickers.length, asset: asset);
    return state.copyWith(
      stickers: List.of(state.stickers)..add(newSticker),
      selectedAssetId: newSticker.id,
    );
  }

  PhotoboothState _mapStickerDraggedToState(
    PhotoStickerDragged event,
    PhotoboothState state,
  ) {
    final asset = event.sticker;
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere((element) => element.id == asset.id);
    final sticker = stickers.removeAt(index);
    stickers.add(
      sticker.copyWith(
        position: PhotoAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: PhotoAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: PhotoConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );
    return state.copyWith(stickers: stickers, selectedAssetId: asset.id);
  }

  PhotoboothState _mapDeleteStickerTappedToState(
    PhotoDeleteStickerTapped event,
    PhotoboothState state,
  ) {
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere((c) => c.id == event.sticker.id);
    final stickerExists = index != -1;

    if (stickerExists) {
      stickers.removeAt(index);
    }

    return state.copyWith(stickers: stickers);
  }
}