module CustomMemoizedHelpers
  def is_expect_caused
    expect { subject }
  end
end
