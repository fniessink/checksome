NCLOC metric.

    @ncloc_meets_target = (value, target) ->
      return value <= target

Duplcation metric

    @duplication_meets_target = (value, target) ->
      return value <= target

Test results

    @test_result_meets_target = (value, target) ->
      return value <= target
