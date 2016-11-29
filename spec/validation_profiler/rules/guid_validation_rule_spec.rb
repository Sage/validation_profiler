RSpec.describe ValidationProfiler::Rules::GuidValidationRule do

  describe '#validate' do

    context 'when a valid guid is required' do
      context 'and no value is specified' do
        it 'should return false' do
          obj = {}
          expect(subject.validate(obj, :guid, { required: true })).to eq(false)
        end
      end
    end

    context 'when a valid guid is specified' do
      context 'that is 32 chars in length' do
        context 'that is lower case' do
          it 'should return true' do
            obj = { guid: 'ca761232ed4211cebacd00aa0057b223'}
            expect(subject.validate(obj, :guid)).to eq(true)
          end
        end
        context 'that is uppercase' do
          it 'should return true' do
            obj = { guid: 'ca761232ed4211cebacd00aa0057b223'.upcase }
            expect(subject.validate(obj, :guid)).to eq(true)
          end
        end
      end
      context 'that is 36 chars in length' do
        context 'and hyphens are allowed' do
          context 'that is lower case' do
            it 'should return true' do
              obj = { guid: 'CA761232-ED42-11CE-BACD-00AA0057B223'.downcase }
              expect(subject.validate(obj, :guid, { hyphens: true })).to eq(true)
            end
          end
          context 'that is upper case' do
            it 'should return true' do
              obj = { guid: 'CA761232-ED42-11CE-BACD-00AA0057B223' }
              expect(subject.validate(obj, :guid, { hyphens: true })).to eq(true)
            end
          end
        end
        context 'and hyphens are not allowed' do
          it 'should return false' do
            obj = { guid: 'CA761232-ED42-11CE-BACD-00AA0057B223' }
            expect(subject.validate(obj, :guid)).to eq(false)
          end
        end
      end
      context 'that is 38 chars in length' do
        context 'and brackets are allowed' do
          context 'that is lower case' do
            it 'should return true' do
              obj = { guid: '{CA761232-ED42-11CE-BACD-00AA0057B223}'.downcase }
              expect(subject.validate(obj, :guid, { hyphens: true, brackets: true })).to eq(true)
            end
          end
          context 'that is upper case' do
            it 'should return true' do
              obj = { guid: '{CA761232-ED42-11CE-BACD-00AA0057B223}' }
              expect(subject.validate(obj, :guid, { hyphens: true, brackets: true })).to eq(true)
            end
          end
        end
        context 'and brackets are not allowed' do
          it 'should return false' do
            obj = { guid: '{CA761232-ED42-11CE-BACD-00AA0057B223}' }
            expect(subject.validate(obj, :guid, { hyphens: true })).to eq(false)
          end
        end
      end
    end

    context 'when an invalid guid is specified' do
      it 'should return false' do
        obj = { guid: 'abc' }
        expect(subject.validate(obj, :guid)).to eq(false)
      end
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:id)).to eq('id is not a valid Guid')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:time, { message: 'Please enter a valid Guid' })).to eq('Please enter a valid Guid')
    end

  end

end