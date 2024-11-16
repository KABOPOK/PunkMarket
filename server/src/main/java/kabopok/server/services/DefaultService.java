package kabopok.server.services;

import jakarta.persistence.EntityNotFoundException;

import java.util.Optional;
import java.util.UUID;
import java.util.function.Function;

import static java.lang.String.format;

abstract public class DefaultService {

  private static final String NOT_FOUND = "Entity with %s %s not found";

  protected static  <T> T getOrThrow(UUID id, Function<UUID, Optional<T>> function) {
    return function.apply(id).orElseThrow(() -> new EntityNotFoundException(format(NOT_FOUND, "id", id)));
  }

  protected static  <T> T getOrThrow(String number, Function<String, Optional<T>> function) {
    return function.apply(number).orElseThrow(() -> new EntityNotFoundException(format(NOT_FOUND, "number", number)));
  }

}
