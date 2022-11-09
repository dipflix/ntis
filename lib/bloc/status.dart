enum BlocActionStatus {
  loading,
  done,
  error,
}

extension BlocActionStatus_X on BlocActionStatus {
  bool get isLoading => this == BlocActionStatus.loading;

  bool get isDone => this == BlocActionStatus.done;

  bool get isError => this == BlocActionStatus.error;
}
