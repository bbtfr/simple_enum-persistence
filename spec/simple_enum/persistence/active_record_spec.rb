require 'spec_helper'

describe SimpleEnum::Persistence, active_record: true do
  fake_active_record(:klass) do
    as_enum :gender, Gender, persistence: true, with: []
  end

  context 'generate_enum_instance_accessors_for' do
    subject { klass.new(gender: :female) }

    context '#gender' do
      it 'delegates to accessor' do
        expect(subject.gender).to eq :female
      end
    end

    context '#gender=' do
      it 'delegates to accessor' do
        subject.gender = :male
        expect(subject.gender).to eq :male
      end
    end

    context '#gender?' do
      it 'delegates to accessor' do
        subject.gender = nil
        expect(subject.gender?).to be_falsey
      end
    end
  end

  context 'generate_enum_dirty_methods_for' do
    subject { klass.new }

    it 'does not respond to #gender_changed?' do
      expect(subject).to_not respond_to(:gender_changed?)
    end

    it 'does not responds to #gender_was' do
      expect(subject).to_not respond_to(:gender_was)
    end

    context 'with: :dirty' do
      fake_active_record(:klass) { as_enum :gender, Gender, persistence: true, with: [:dirty] }
      subject { klass.new(gender: :female) }

      it 'delegates #gender_changed? to accessor' do
        expect(subject.gender_changed?).to be_truthy
      end

      it 'delegates #gender_was to accessor' do
        expect(subject.gender_was).to eq nil
      end
    end
  end

  context 'generate_enum_attribute_methods_for' do
    subject { klass.new }

    it 'does not respond to #male? or #female?' do
      expect(subject).to_not respond_to(:male?)
      expect(subject).to_not respond_to(:female?)
    end

    it 'does not respond to #male! or #female!' do
      expect(subject).to_not respond_to(:male!)
      expect(subject).to_not respond_to(:female!)
    end

    context 'with: :attribute' do
      fake_active_record(:klass) { as_enum :gender, Gender, persistence: true, with: [:attribute] }
      subject { klass.new(gender: :male) }

      it 'delegates #gender? to accessor' do
        expect(subject.gender?).to be_truthy
      end

      it 'delegates #male? to accessor' do
        expect(subject.male?).to be_truthy
      end

      it 'delegates #female? to accessor' do
        expect(subject.female?).to be_falsey
      end

      it 'delegates #male! to accessor' do
        expect(subject.male!).to eq "male"
        expect(subject.male?).to be_truthy
      end

      it 'delegates #female! to accessor' do
        expect(subject.female!).to eq "female"
        expect(subject.female?).to be_truthy
      end
    end

    context 'with a prefix' do
      fake_active_record(:klass) { as_enum :gender, Gender, persistence: true, with: [:attribute], prefix: true }
      subject { klass.new(gender: :male) }

      it 'delegates #gender? to accessor' do
        expect(subject.gender?).to be_truthy
      end

      it 'delegates #gender_male? to accessor' do
        expect(subject.gender_male?).to be_truthy
      end

      it 'delegates #gender_female? to accessor' do
        expect(subject.gender_female?).to be_falsey
      end

      it 'delegates #gender_male! to accessor' do
        expect(subject.gender_male!).to eq "male"
        expect(subject.gender_male?).to be_truthy
      end

      it 'delegates #gender_female! to accessor' do
        expect(subject.gender_female!).to eq "female"
        expect(subject.gender_female?).to be_truthy
      end
    end
  end
end
