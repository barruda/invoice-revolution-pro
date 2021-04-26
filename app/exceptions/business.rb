# frozen_string_literal: true

module Business
  class BusinessException < StandardError
  end

  class InvalidTransactionException < BusinessException
  end

  class NotFoundException < BusinessException
  end
end
