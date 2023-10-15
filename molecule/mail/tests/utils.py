# Helper functions
def _assert_equals(value1, value2, error_message):
    if value1 != value2:
        raise AssertionError(error_message)
